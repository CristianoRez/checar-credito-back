<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Loan;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    // Função para exibir empréstimos
    public function AllLoans()
    {
        return Loan::with('client_id')
            ->with('bank_id')
            ->with('modality_id')
            ->get();
    }

    // Função para apagar os empréstimos
    public function EraseLoan(Request $request)
    {
        Loan::where('id', $request->id)->delete();
    }
}
