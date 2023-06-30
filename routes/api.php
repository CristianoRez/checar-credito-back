<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\ClientController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::controller(ClientController::class)->group(function () {
    Route::post('checar-bancos', 'CheckBanks');
    Route::post('melhores-ofertas', 'BestOffer');
    Route::post('solicitar-emprestimo','GetALoan');
});
Route::controller(AdminController::class)->group(function () {
    route::get('todos-emprestimos', 'AllLoans');
    route::post('apagar-emprestimo', 'EraseLoan');
});

