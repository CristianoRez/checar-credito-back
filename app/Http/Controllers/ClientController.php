<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Bank;
use App\Models\Client;
use App\Models\Loan;
use App\Models\Modality;
use App\Models\Offer;
use Illuminate\Http\Request;

class ClientController extends Controller
{
    // Função para acessar a API
    private function GOSATAPI($url, $params)
    {
        $params = http_build_query($params);
        $curl = curl_init($url . '?' . $params);
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $data = curl_exec($curl);
        return json_decode($data);
    }

    // Função que retorna as ofertas de acordo com o cpf
    private function GetBanksAndOffers($cpf)
    {
        $url = 'https://dev.gosat.org/api/v1/simulacao/credito';
        $params = [
            'cpf' => $cpf
        ];
        return $this->GOSATAPI($url, $params);
    }

    // Função que salva os clientes no banco de dados
    private function SendClientToDB($cpf)
    {
        $cpf = str_replace(['.', '-'], '', $cpf);
        if (!Client::where('cpf', $cpf)->exists()) {
            Client::create(['cpf' => $cpf]);
        }
        return Client::where('cpf', $cpf)->first()->id;
    }

    // Função que salva todos os bancos, modalidades e ofertas que já foram expostas 
    private function SendToDB($clientId, $cpf, $result)
    {
        foreach ($result->instituicoes as $bank) {
            if (!Bank::where('id', $bank->id)->exists()) {
                Bank::create([
                    'id' => $bank->id,
                    'name' => $bank->nome
                ]);
            }
            foreach ($bank->modalidades as $modality) {
                if (!Modality::where('code', $modality->codigo)->where('bank_id', $bank->id)->exists()) {
                    Modality::create([
                        'name' => $modality->nome,
                        'code' => $modality->codigo,
                        'bank_id' => $bank->id
                    ]);
                }
                $modalityId = Modality::where('code', $modality->codigo)->where('bank_id', $bank->id)->first()->id;
                $offer = Offer::where('client_id', $clientId)->where('bank_id', $bank->id)->where('modality_id', $modalityId)->exists();
                if ($offer) {
                } else {
                    Offer::create([
                        'client_id' => $clientId,
                        'bank_id' => $bank->id,
                        'modality_id' => $modalityId,
                        'qntparcelamin' => $modality->oferta->QntParcelaMin,
                        'qntparcelamax' => $modality->oferta->QntParcelaMax,
                        'valormin' => $modality->oferta->valorMin,
                        'valormax' => $modality->oferta->valorMax,
                        'jurosmes' => $modality->oferta->jurosMes
                    ]);
                }
            };
        }
    }

    // Função que retorna os bancos e ofertas do cliente de acordo com o cpf
    public function CheckBanks(Request $request)
    {
        $jsonDecodeBanks = $this->GetBanksAndOffers($request->cpf);

        $countIns = count($jsonDecodeBanks->instituicoes);
        $instituicoes = [];
        for ($i = 0; $i <= $countIns; $i++) {
            if (isset($jsonDecodeBanks->instituicoes[$i])) {
                $countMod = count($jsonDecodeBanks->instituicoes[$i]->modalidades);
                $modalidades = [];
                for ($m = 0; $m < $countMod; $m++) {
                    $url = 'https://dev.gosat.org/api/v1/simulacao/oferta';
                    $params = [
                        'cpf' => $request->cpf,
                        'instituicao_id' => $jsonDecodeBanks->instituicoes[$i]->id,
                        'codModalidade' => $jsonDecodeBanks->instituicoes[$i]->modalidades[$m]->cod
                    ];
                    $jsonDecodeOferta = $this->GOSATAPI($url, $params);
                    $modalidades[] = [
                        'codigo' => $jsonDecodeBanks->instituicoes[$i]->modalidades[$m]->cod,
                        'nome' => $jsonDecodeBanks->instituicoes[$i]->modalidades[$m]->nome,
                        'oferta' => $jsonDecodeOferta
                    ];
                }
                $instituicoes[] = [
                    'id' => $jsonDecodeBanks->instituicoes[$i]->id,
                    'nome' => $jsonDecodeBanks->instituicoes[$i]->nome,
                    'modalidades' => $modalidades
                ];
            }
        }

        foreach ($instituicoes as &$instituicao) {
            usort($instituicao['modalidades'], function ($a, $b) {
                $jurosA = $a['oferta']->jurosMes;
                $jurosB = $b['oferta']->jurosMes;

                return $jurosA <=> $jurosB;
            });
        }
        usort($instituicoes, function ($a, $b) {
            $jurosA = $a['modalidades'][0]['oferta']->jurosMes;
            $jurosB = $b['modalidades'][0]['oferta']->jurosMes;

            return $jurosA <=> $jurosB;
        });

        $result = (object) ['instituicoes' => $instituicoes];
        $result = json_decode(json_encode($result));

        $clientId = $this->SendClientToDB($request->cpf);
        $this->SendToDB($clientId, $request->cpf, $result);
        return $result;
    }

    // Função que retorna as melhores oferta de acordo com o credito solicitado
    public function BestOffer(Request $request)
    {
        $jsonDecodeBanks = $this->GetBanksAndOffers($request->cpf);
        $countIns = count($jsonDecodeBanks->instituicoes);
        $instituicoes = [];

        for ($i = 0; $i < $countIns; $i++) {

            if (isset($jsonDecodeBanks->instituicoes[$i])) {
                $countMod = count($jsonDecodeBanks->instituicoes[$i]->modalidades);
                $modalidades = [];

                for ($m = 0; $m < $countMod; $m++) {
                    $url = 'https://dev.gosat.org/api/v1/simulacao/oferta';
                    $params = [
                        'cpf' => $request->cpf,
                        'instituicao_id' => $jsonDecodeBanks->instituicoes[$i]->id,
                        'codModalidade' => $jsonDecodeBanks->instituicoes[$i]->modalidades[$m]->cod
                    ];

                    $jsonDecodeOferta = $this->GOSATAPI($url, $params);
                    $amount = $request->credito;

                    if ($amount <= $jsonDecodeOferta->valorMax and $amount >= $jsonDecodeOferta->valorMin) {
                        $valorMesMax = (($amount * $jsonDecodeOferta->jurosMes) + $amount) / $jsonDecodeOferta->QntParcelaMin;
                        $valorMesMin = (($amount * $jsonDecodeOferta->jurosMes) + $amount) / $jsonDecodeOferta->QntParcelaMax;

                        $total = $valorMesMax * $jsonDecodeOferta->QntParcelaMin;

                        $parcelas = [
                            "qntmenor" => $jsonDecodeOferta->QntParcelaMin,
                            "menor" => $valorMesMax,
                            "qntmaior" => $jsonDecodeOferta->QntParcelaMax,
                            "maior" => $valorMesMin
                        ];

                        $oferta = (object) [
                            'ValorAPagar' => $total,
                            'ValorSolicitado' => $amount,
                            'TaxaDeJuros' => $jsonDecodeOferta->jurosMes,
                            'Parcelas'  => $parcelas
                        ];

                        $modalidades[] = [
                            'codigo' => $jsonDecodeBanks->instituicoes[$i]->modalidades[$m]->cod,
                            'nome' => $jsonDecodeBanks->instituicoes[$i]->modalidades[$m]->nome,
                            'oferta' => $oferta
                        ];
                    };
                }
                if (!empty($modalidades)) {
                    $instituicoes[] = [
                        'id' => $jsonDecodeBanks->instituicoes[$i]->id,
                        'nome' => $jsonDecodeBanks->instituicoes[$i]->nome,
                        'modalidades' => $modalidades
                    ];
                }
            }
        }

        foreach ($instituicoes as &$instituicao) {
            usort($instituicao['modalidades'], function ($a, $b) {
                $jurosA = $a['oferta']->TaxaDeJuros;
                $jurosB = $b['oferta']->TaxaDeJuros;

                return $jurosA <=> $jurosB;
            });
        }
        usort($instituicoes, function ($a, $b) {
            $jurosA = $a['modalidades'][0]['oferta']->TaxaDeJuros;
            $jurosB = $b['modalidades'][0]['oferta']->TaxaDeJuros;

            return $jurosA <=> $jurosB;
        });
        $result = ['instituicoes' => $instituicoes];

        return $result;
    }

    // Função para solititar um empréstimo
    public function GetALoan(Request $request)
    {
        $url = 'https://dev.gosat.org/api/v1/simulacao/oferta';
        $params = [
            'cpf' => $request->cpf,
            'instituicao_id' => $request->instituicaoId,
            'codModalidade' => $request->modalidadeCod
        ];
        $jsonDecodeOferta = $this->GOSATAPI($url, $params);
        $clientId = Client::where('cpf', $request->cpf)->first()->id;
        $modalityId = Modality::where('code', $request->modalidadeCod)->where('bank_id', $request->instituicaoId)->first()->id;
        $amountPayable = $request->credito * $jsonDecodeOferta->jurosMes + $request->credito;
        $installmentsVal = $amountPayable / $request->parcelas;
        if (Loan::where('client_id', $clientId)->where('bank_id', $request->instituicaoId)->where('modality_id', $modalityId)->exists()) {
            $return = [
                'Answer' => 1,
                'Loan' => Loan::with('client_id')
                    ->with('bank_id')
                    ->with('modality_id')
                    ->where('client_id', $clientId)
                    ->where('bank_id', $request->instituicaoId)
                    ->where('modality_id', $modalityId)
                    ->first()
            ];
            return $return;
        } else {
            Loan::create([
                'client_id' => $clientId,
                'bank_id' => $request->instituicaoId,
                'modality_id' => $modalityId,
                'amount_received' => $request->credito,
                'amount_payable' => $amountPayable,
                'interest_rate' => $jsonDecodeOferta->jurosMes,
                'installments' => $request->parcelas,
                'installments_value' => $installmentsVal
            ]);

            $return = [
                'Answer' => 0,
                'Loan' => Loan::with('client_id')
                    ->with('bank_id')
                    ->with('modality_id')
                    ->where('client_id', $clientId)
                    ->where('bank_id', $request->instituicaoId)
                    ->where('modality_id', $modalityId)
                    ->first()
            ];
            return $return;
        }
    }
}
