-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 13, 2019 at 07:46 AM
-- Server version: 5.7.23
-- PHP Version: 7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cryptofunds`
--

-- --------------------------------------------------------

--
-- Table structure for table `amount_wallet`
--

CREATE TABLE `amount_wallet` (
  `id` int(11) NOT NULL,
  `fund_id` int(11) NOT NULL,
  `coin_amount_id` int(11) NOT NULL,
  `address` varchar(80) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `amount_wallet`
--

INSERT INTO `amount_wallet` (`id`, `fund_id`, `coin_amount_id`, `address`, `created_on`, `updated`) VALUES
(1, 1, 3, '0x1533Dd59b655838D5D6df2bb9f315d6D5fdf2f1B', '2018-12-15 10:27:26', '2018-12-15 10:27:26'),
(2, 1, 8, '0x862a00bcb34ab46f6c037c97a4b5865c72afb003', '2018-12-15 10:27:26', '2018-12-15 10:27:26'),
(3, 1, 9, '0x039510ffd23b23963457266827c633cf85ab0f5d', '2018-12-15 10:27:26', '2018-12-15 10:27:26'),
(4, 1, 5, '0x1533Dd59b655838D5D6df2bb9f315d6D5fdf2f1B', '2018-12-15 10:27:26', '2018-12-15 10:27:26'),
(5, 1, 6, '0x1533Dd59b655838D5D6df2bb9f315d6D5fdf2f1B', '2018-12-15 10:28:24', '2018-12-15 10:28:24'),
(6, 1, 7, '0x1533Dd59b655838D5D6df2bb9f315d6D5fdf2f1B', '2018-12-15 10:28:24', '2018-12-15 10:28:24');

-- --------------------------------------------------------

--
-- Table structure for table `coins`
--

CREATE TABLE `coins` (
  `id` int(11) NOT NULL,
  `symbol` varchar(26) NOT NULL COMMENT 'ccxt symbol',
  `full_name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `coins`
--

INSERT INTO `coins` (`id`, `symbol`, `full_name`, `url`, `created_on`, `updated`) VALUES
(1, 'BNB', 'binance token', 'https://coinmarketcap.com/currencies/binance-coin/', '2018-12-13 12:27:16', '2018-12-13 12:31:02'),
(2, 'OKB', 'okex token', 'https://www.coingecko.com/en/coins/okb', '2018-12-13 12:30:53', '2018-12-13 12:30:53'),
(3, 'ZB', 'zb token', 'https://coinmarketcap.com/currencies/zb/', '2018-12-13 12:36:29', '2018-12-13 12:36:44'),
(4, 'QASH', 'liquid token', 'https://coinmarketcap.com/currencies/qash/', '2018-12-13 12:36:29', '2018-12-13 12:36:29'),
(5, 'HT', 'huobi token', 'https://coinmarketcap.com/currencies/huobi-token/', '2018-12-13 12:36:29', '2018-12-13 12:36:29'),
(6, 'BIX', 'bibox token', 'https://coinmarketcap.com/currencies/bibox-token/', '2018-12-13 12:36:29', '2018-12-13 12:36:29'),
(7, 'KCS', 'kucoin shares', 'https://coinmarketcap.com/currencies/kucoin-shares/', '2018-12-13 12:36:29', '2018-12-13 12:36:29');

-- --------------------------------------------------------

--
-- Table structure for table `coin_amount`
--

CREATE TABLE `coin_amount` (
  `id` int(11) NOT NULL,
  `component_id` int(11) NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `coin_amount`
--

INSERT INTO `coin_amount` (`id`, `component_id`, `amount`, `created_on`, `updated`) VALUES
(3, 1, '862.01281000', '2018-12-15 09:57:30', '2018-12-15 09:57:30'),
(4, 2, '5375.94377490', '2018-12-15 09:57:30', '2019-02-12 11:56:25'),
(5, 3, '33038.16859000', '2018-12-15 09:59:10', '2018-12-15 09:59:10'),
(6, 4, '18282.30367200', '2018-12-15 09:59:10', '2018-12-15 09:59:10'),
(7, 5, '3572.30906000', '2018-12-15 10:02:20', '2018-12-15 10:02:20'),
(8, 6, '18587.39384435', '2018-12-15 10:02:20', '2019-02-12 11:44:04'),
(9, 7, '6466.33927889', '2018-12-15 10:04:00', '2019-02-12 11:44:08');

-- --------------------------------------------------------

--
-- Table structure for table `coin_rates`
--

CREATE TABLE `coin_rates` (
  `id` int(11) NOT NULL,
  `coin_id` int(11) NOT NULL,
  `exchange_id` int(11) NOT NULL,
  `quote` varchar(60) NOT NULL,
  `rate` decimal(18,8) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `coin_rates`
--

INSERT INTO `coin_rates` (`id`, `coin_id`, `exchange_id`, `quote`, `rate`, `created_on`, `updated`) VALUES
(1, 1, 2, 'BTC', '0.00254100', '2018-12-15 10:38:01', '2019-02-12 11:38:00'),
(2, 2, 6, 'BTC', '0.00017763', '2018-12-15 10:38:01', '2019-01-03 12:10:00'),
(3, 3, 7, 'BTC', '0.00003595', '2018-12-15 10:38:01', '2019-02-12 11:38:01'),
(4, 4, 5, 'BTC', '0.00001920', '2018-12-15 10:38:01', '2019-02-12 11:34:03'),
(5, 5, 3, 'BTC', '0.00032515', '2018-12-15 10:38:01', '2019-02-12 11:38:03'),
(6, 6, 1, 'BTC', '0.00003699', '2018-12-15 10:38:01', '2019-02-12 11:34:09'),
(7, 7, 4, 'BTC', '0.00009590', '2018-12-15 10:38:01', '2019-02-12 11:34:10');

-- --------------------------------------------------------

--
-- Table structure for table `exchanges`
--

CREATE TABLE `exchanges` (
  `id` int(11) NOT NULL,
  `name_id` varchar(26) NOT NULL COMMENT 'ccxt id',
  `fullname` varchar(60) DEFAULT NULL,
  `url` varchar(60) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `exchanges`
--

INSERT INTO `exchanges` (`id`, `name_id`, `fullname`, `url`, `created_on`, `updated_on`) VALUES
(1, 'bibox', 'bibox', 'https://www.bibox.com', '2018-12-13 11:58:30', '2018-12-13 12:00:11'),
(2, 'binance', 'binance', 'https://www.binance.com/', '2018-12-13 12:00:58', '2018-12-13 12:00:58'),
(3, 'huobipro', 'huobi pro', 'https://www.hbg.com', '2018-12-13 12:04:40', '2018-12-13 12:04:40'),
(4, 'kucoin', 'kucoin', 'https://www.kucoin.com', '2018-12-13 12:04:40', '2018-12-13 12:04:40'),
(5, 'liquid', 'liquid', 'https://www.liquid.com', '2018-12-13 12:06:56', '2018-12-13 12:06:56'),
(6, 'okex', 'okex', 'https://www.okex.com', '2018-12-13 12:06:56', '2018-12-13 12:06:56'),
(7, 'zb', 'zb', 'https://www.zb.com', '2018-12-13 12:06:56', '2018-12-13 12:06:56');

-- --------------------------------------------------------

--
-- Table structure for table `funds`
--

CREATE TABLE `funds` (
  `id` int(11) NOT NULL,
  `name` varchar(26) NOT NULL,
  `units` decimal(12,2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `funds`
--

INSERT INTO `funds` (`id`, `name`, `units`, `description`, `created_on`, `updated`) VALUES
(1, 'CryptoX Fund', '85632.00', 'A fund that only buys into cryptocurrency exchanges tokens and coins. ', '2018-12-13 11:40:11', '2019-02-12 11:34:00');

-- --------------------------------------------------------

--
-- Table structure for table `fund_components`
--

CREATE TABLE `fund_components` (
  `id` int(11) NOT NULL,
  `fund_id` int(11) NOT NULL,
  `coin_id` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fund_components`
--

INSERT INTO `fund_components` (`id`, `fund_id`, `coin_id`, `created_on`, `updated`) VALUES
(1, 1, 1, '2018-12-15 09:29:15', '2018-12-15 09:29:15'),
(2, 1, 2, '2018-12-15 09:29:15', '2018-12-15 09:29:15'),
(3, 1, 3, '2018-12-15 09:29:15', '2018-12-15 09:29:15'),
(4, 1, 4, '2018-12-15 09:29:15', '2018-12-15 09:29:15'),
(5, 1, 5, '2018-12-15 09:29:15', '2018-12-15 09:29:15'),
(6, 1, 6, '2018-12-15 09:29:15', '2018-12-15 09:29:15'),
(7, 1, 7, '2018-12-15 09:29:15', '2018-12-15 09:29:15');

-- --------------------------------------------------------

--
-- Table structure for table `fund_nav`
--

CREATE TABLE `fund_nav` (
  `id` int(11) NOT NULL,
  `fund_id` int(11) NOT NULL,
  `value` decimal(18,8) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fund_nav`
--

INSERT INTO `fund_nav` (`id`, `fund_id`, `value`, `created_on`, `updated`) VALUES
(1, 1, '0.00008774', '2018-12-17 13:59:03', '2018-12-17 13:59:03'),
(2, 1, '0.00008774', '2018-12-17 13:59:52', '2018-12-17 13:59:52'),
(3, 1, '0.00008624', '2018-12-18 12:37:49', '2018-12-18 12:37:49'),
(4, 1, '0.00008621', '2018-12-18 12:56:09', '2018-12-18 12:56:09'),
(5, 1, '0.00008611', '2018-12-18 12:57:06', '2018-12-18 12:57:06'),
(6, 1, '0.00008614', '2018-12-18 12:58:07', '2018-12-18 12:58:07'),
(7, 1, '0.00008629', '2018-12-19 05:17:16', '2018-12-19 05:17:16'),
(8, 1, '0.00008595', '2018-12-19 06:57:42', '2018-12-19 06:57:42'),
(9, 1, '0.00008570', '2018-12-19 07:22:14', '2018-12-19 07:22:14'),
(10, 1, '0.00008554', '2018-12-19 07:40:59', '2018-12-19 07:40:59'),
(11, 1, '0.00008566', '2018-12-19 07:52:05', '2018-12-19 07:52:05'),
(12, 1, '0.00008566', '2018-12-19 07:57:08', '2018-12-19 07:57:08'),
(13, 1, '0.00007923', '2019-01-03 11:53:03', '2019-01-03 11:53:03'),
(14, 1, '0.00007922', '2019-01-03 11:53:46', '2019-01-03 11:53:46'),
(15, 1, '0.00007938', '2019-01-03 11:57:55', '2019-01-03 11:57:55'),
(16, 1, '0.00007925', '2019-01-03 12:06:14', '2019-01-03 12:06:14'),
(17, 1, '0.00007925', '2019-01-03 12:10:07', '2019-01-03 12:10:07'),
(18, 1, '0.00008327', '2019-02-12 11:34:10', '2019-02-12 11:34:10'),
(19, 1, '0.00008337', '2019-02-12 11:36:17', '2019-02-12 11:36:17'),
(20, 1, '0.00008332', '2019-02-12 11:38:12', '2019-02-12 11:38:12');

-- --------------------------------------------------------

--
-- Table structure for table `fund_unit_ledger`
--

CREATE TABLE `fund_unit_ledger` (
  `id` int(11) NOT NULL,
  `fund_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `txn` enum('SUBSCRIBED','REDEEMED') NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `nav_btc` decimal(18,8) NOT NULL,
  `nav_usdt` decimal(18,2) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fund_unit_ledger`
--

INSERT INTO `fund_unit_ledger` (`id`, `fund_id`, `user_id`, `txn`, `amount`, `nav_btc`, `nav_usdt`, `created_on`, `updated`) VALUES
(1, 1, 1, 'SUBSCRIBED', '20865.00', '0.00007958', '7232.00', '2019-01-03 09:07:29', '2019-01-03 09:20:56'),
(2, 1, 2, 'SUBSCRIBED', '20844.00', '0.00007958', '7225.00', '2019-01-03 09:09:38', '2019-01-03 09:21:01'),
(3, 1, 3, 'SUBSCRIBED', '8184.00', '0.00007958', '2837.00', '2019-01-03 09:09:38', '2019-01-03 12:22:56'),
(4, 1, 4, 'SUBSCRIBED', '4989.00', '0.00007958', '1729.00', '2019-01-03 09:09:38', '2019-01-03 09:21:17'),
(5, 1, 5, 'SUBSCRIBED', '16930.00', '0.00007958', '5868.00', '2019-01-03 09:09:38', '2019-01-03 09:21:23'),
(6, 1, 6, 'SUBSCRIBED', '12455.00', '0.00007958', '4317.00', '2019-01-03 09:09:38', '2019-01-03 09:21:29'),
(7, 1, 7, 'SUBSCRIBED', '1365.00', '0.00007958', '473.00', '2019-01-03 09:09:38', '2019-01-03 09:21:34');

-- --------------------------------------------------------

--
-- Table structure for table `fund_users`
--

CREATE TABLE `fund_users` (
  `id` int(11) NOT NULL,
  `display_name` varchar(60) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `wp_id` int(11) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fund_users`
--

INSERT INTO `fund_users` (`id`, `display_name`, `email`, `wp_id`, `created_on`, `updated`) VALUES
(1, 'ERA', NULL, NULL, '2019-01-03 09:06:32', '2019-01-03 09:06:54'),
(2, 'Lee Chee Wee', NULL, NULL, '2019-01-03 09:06:32', '2019-01-03 09:06:32'),
(3, 'Seah Boon Kiat', NULL, NULL, '2019-01-03 09:06:32', '2019-01-03 09:06:32'),
(4, 'Seah Keng Siong', NULL, NULL, '2019-01-03 09:06:32', '2019-01-03 09:06:32'),
(5, 'Ng Chai Lin', NULL, NULL, '2019-01-03 09:06:32', '2019-01-03 09:06:32'),
(6, 'Yue Ye', NULL, NULL, '2019-01-03 09:06:32', '2019-01-03 09:06:32'),
(7, 'Zhou Chun Mei', NULL, NULL, '2019-01-03 09:06:32', '2019-01-03 09:06:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `amount_wallet`
--
ALTER TABLE `amount_wallet`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fund_id` (`fund_id`),
  ADD KEY `amount_wallet_ibfk_2` (`coin_amount_id`);

--
-- Indexes for table `coins`
--
ALTER TABLE `coins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `symbol` (`symbol`);

--
-- Indexes for table `coin_amount`
--
ALTER TABLE `coin_amount`
  ADD PRIMARY KEY (`id`),
  ADD KEY `component_id` (`component_id`);

--
-- Indexes for table `coin_rates`
--
ALTER TABLE `coin_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coin_id` (`coin_id`),
  ADD KEY `exchange_id` (`exchange_id`);

--
-- Indexes for table `exchanges`
--
ALTER TABLE `exchanges`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name_id` (`name_id`);

--
-- Indexes for table `funds`
--
ALTER TABLE `funds`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fund_components`
--
ALTER TABLE `fund_components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fund_id` (`fund_id`),
  ADD KEY `coin_id` (`coin_id`);

--
-- Indexes for table `fund_nav`
--
ALTER TABLE `fund_nav`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fund_id` (`fund_id`);

--
-- Indexes for table `fund_unit_ledger`
--
ALTER TABLE `fund_unit_ledger`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fund_id` (`fund_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `fund_users`
--
ALTER TABLE `fund_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `wp_id` (`wp_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `amount_wallet`
--
ALTER TABLE `amount_wallet`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `coins`
--
ALTER TABLE `coins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `coin_amount`
--
ALTER TABLE `coin_amount`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `coin_rates`
--
ALTER TABLE `coin_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `exchanges`
--
ALTER TABLE `exchanges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `funds`
--
ALTER TABLE `funds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fund_components`
--
ALTER TABLE `fund_components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `fund_nav`
--
ALTER TABLE `fund_nav`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `fund_unit_ledger`
--
ALTER TABLE `fund_unit_ledger`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `fund_users`
--
ALTER TABLE `fund_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `amount_wallet`
--
ALTER TABLE `amount_wallet`
  ADD CONSTRAINT `amount_wallet_ibfk_1` FOREIGN KEY (`fund_id`) REFERENCES `funds` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `amount_wallet_ibfk_2` FOREIGN KEY (`coin_amount_id`) REFERENCES `coin_amount` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `coin_amount`
--
ALTER TABLE `coin_amount`
  ADD CONSTRAINT `coin_amount_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `fund_components` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `coin_rates`
--
ALTER TABLE `coin_rates`
  ADD CONSTRAINT `coin_rates_ibfk_1` FOREIGN KEY (`coin_id`) REFERENCES `coins` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `coin_rates_ibfk_2` FOREIGN KEY (`exchange_id`) REFERENCES `exchanges` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `fund_components`
--
ALTER TABLE `fund_components`
  ADD CONSTRAINT `fund_components_ibfk_1` FOREIGN KEY (`fund_id`) REFERENCES `funds` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fund_components_ibfk_2` FOREIGN KEY (`coin_id`) REFERENCES `coins` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `fund_nav`
--
ALTER TABLE `fund_nav`
  ADD CONSTRAINT `fund_nav_ibfk_1` FOREIGN KEY (`fund_id`) REFERENCES `funds` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `fund_unit_ledger`
--
ALTER TABLE `fund_unit_ledger`
  ADD CONSTRAINT `fund_unit_ledger_ibfk_1` FOREIGN KEY (`fund_id`) REFERENCES `funds` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fund_unit_ledger_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `fund_users` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
