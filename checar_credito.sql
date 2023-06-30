-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 30-Jun-2023 às 21:08
-- Versão do servidor: 10.4.28-MariaDB
-- versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `checar_credito`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `banks`
--

CREATE TABLE `banks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `banks`
--

INSERT INTO `banks` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Banco PingApp', '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(2, 'Financeira Assert', '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(3, 'Banco ATR SA', '2023-06-28 16:11:42', '2023-06-28 16:11:42');

-- --------------------------------------------------------

--
-- Estrutura da tabela `clients`
--

CREATE TABLE `clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cpf` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `clients`
--

INSERT INTO `clients` (`id`, `cpf`, `created_at`, `updated_at`) VALUES
(1, '11111111111', '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(2, '12312312312', '2023-06-28 16:11:42', '2023-06-28 16:11:42'),
(3, '22222222222', '2023-06-28 16:12:04', '2023-06-28 16:12:04');

-- --------------------------------------------------------

--
-- Estrutura da tabela `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `loans`
--

CREATE TABLE `loans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `bank_id` bigint(20) UNSIGNED NOT NULL,
  `modality_id` bigint(20) UNSIGNED NOT NULL,
  `amount_received` decimal(8,2) NOT NULL,
  `amount_payable` decimal(8,2) NOT NULL,
  `interest_rate` double(8,4) NOT NULL,
  `installments` int(11) NOT NULL,
  `installments_value` double(10,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(2, '2019_08_19_000000_create_failed_jobs_table', 1),
(3, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(4, '2023_06_27_202453_create_clients_table', 1),
(5, '2023_06_27_204319_create_banks_table', 1),
(6, '2023_06_27_204820_create_modalities_table', 1),
(7, '2023_06_27_205247_create_offers_table', 1),
(10, '2023_06_28_141611_create_loans_table', 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `modalities`
--

CREATE TABLE `modalities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `bank_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `modalities`
--

INSERT INTO `modalities` (`id`, `code`, `name`, `bank_id`, `created_at`, `updated_at`) VALUES
(1, '3', 'crédito pessoal', 1, '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(2, '13', 'crédito consignado', 1, '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(3, 'a50ed2ed-2b8b-4cc7-ac95-71a5568b34ce', 'crédito pessoal', 2, '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(4, '17', 'Saque FGTS', 1, '2023-06-28 16:11:42', '2023-06-28 16:11:42'),
(5, '33', 'crédito consignado', 3, '2023-06-28 16:11:42', '2023-06-28 16:11:42'),
(6, '56c6dbc9-7109-4a67-953d-4ca2ae6b8051', 'Saque FGTS', 2, '2023-06-28 16:12:04', '2023-06-28 16:12:04'),
(7, '12', 'crédito pessoal', 3, '2023-06-28 16:12:04', '2023-06-28 16:12:04');

-- --------------------------------------------------------

--
-- Estrutura da tabela `offers`
--

CREATE TABLE `offers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `bank_id` bigint(20) UNSIGNED NOT NULL,
  `modality_id` bigint(20) UNSIGNED NOT NULL,
  `qntparcelamin` bigint(20) NOT NULL,
  `qntparcelamax` bigint(20) NOT NULL,
  `valormin` bigint(20) NOT NULL,
  `valormax` bigint(20) NOT NULL,
  `jurosmes` double(8,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `offers`
--

INSERT INTO `offers` (`id`, `client_id`, `bank_id`, `modality_id`, `qntparcelamin`, `qntparcelamax`, `valormin`, `valormax`, `jurosmes`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 12, 48, 5000, 8000, 0.0495, '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(2, 1, 1, 2, 24, 72, 10000, 19250, 0.0118, '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(3, 1, 2, 3, 12, 48, 3000, 7000, 0.0365, '2023-06-28 16:07:53', '2023-06-28 16:07:53'),
(4, 2, 1, 1, 18, 60, 12000, 21250, 0.0118, '2023-06-28 16:11:42', '2023-06-28 16:11:42'),
(5, 2, 1, 4, 12, 48, 15000, 25250, 0.0385, '2023-06-28 16:11:42', '2023-06-28 16:11:42'),
(6, 2, 3, 5, 12, 120, 12236, 58130, 0.0105, '2023-06-28 16:11:42', '2023-06-28 16:11:42'),
(7, 3, 2, 3, 18, 60, 8000, 21250, 0.0501, '2023-06-28 16:12:04', '2023-06-28 16:12:04'),
(8, 3, 2, 6, 18, 60, 500, 6250, 0.0409, '2023-06-28 16:12:04', '2023-06-28 16:12:04'),
(9, 3, 3, 7, 12, 48, 5140, 18250, 0.0395, '2023-06-28 16:12:04', '2023-06-28 16:12:04');

-- --------------------------------------------------------

--
-- Estrutura da tabela `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `banks`
--
ALTER TABLE `banks`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Índices para tabela `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loans_client_id_foreign` (`client_id`),
  ADD KEY `loans_bank_id_foreign` (`bank_id`),
  ADD KEY `loans_modality_id_foreign` (`modality_id`);

--
-- Índices para tabela `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `modalities`
--
ALTER TABLE `modalities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `modalities_bank_id_foreign` (`bank_id`);

--
-- Índices para tabela `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `offers_client_id_foreign` (`client_id`),
  ADD KEY `offers_bank_id_foreign` (`bank_id`),
  ADD KEY `offers_modality_id_foreign` (`modality_id`);

--
-- Índices para tabela `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Índices para tabela `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `banks`
--
ALTER TABLE `banks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `clients`
--
ALTER TABLE `clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `loans`
--
ALTER TABLE `loans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de tabela `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `modalities`
--
ALTER TABLE `modalities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `offers`
--
ALTER TABLE `offers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_bank_id_foreign` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`),
  ADD CONSTRAINT `loans_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `loans_modality_id_foreign` FOREIGN KEY (`modality_id`) REFERENCES `modalities` (`id`);

--
-- Limitadores para a tabela `modalities`
--
ALTER TABLE `modalities`
  ADD CONSTRAINT `modalities_bank_id_foreign` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`);

--
-- Limitadores para a tabela `offers`
--
ALTER TABLE `offers`
  ADD CONSTRAINT `offers_bank_id_foreign` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`),
  ADD CONSTRAINT `offers_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `offers_modality_id_foreign` FOREIGN KEY (`modality_id`) REFERENCES `modalities` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
