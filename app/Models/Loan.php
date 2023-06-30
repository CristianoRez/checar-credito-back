<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Loan extends Model
{
    use HasFactory;
    protected $fillable = [
        'client_id',
        'bank_id',
        'modality_id',
        'amount_received',
        'amount_payable',
        'interest_rate',
        'installments',
        'installments_value'
    ];

    public function client_id(){
        return $this->hasone(Client::class, 'id', 'client_id');
    }

    public function bank_id(){
        return $this->hasone(Bank::class, 'id', 'bank_id');
    }

    public function modality_id(){
        return $this->hasone(Modality::class, 'id', 'modality_id');
    }
}
