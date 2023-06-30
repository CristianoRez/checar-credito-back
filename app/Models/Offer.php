<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Offer extends Model
{
    use HasFactory;
    protected $fillable = [
        'client_id',
        'bank_id',
        'modality_id',
        'qntparcelamin',
        'qntparcelamax',
        'valormin',
        'valormax',
        'jurosmes'
    ];
}
