-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : ven. 03 juin 2022 à 17:15
-- Version du serveur :  10.3.34-MariaDB-0ubuntu0.20.04.1
-- Version de PHP : 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `framework`
--

-- --------------------------------------------------------

--
-- Structure de la table `bankaccounts`
--

CREATE TABLE `bankaccounts` (
  `id` int(11) NOT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `owner_name` varchar(255) DEFAULT NULL,
  `iban` varchar(255) DEFAULT 'OFF0000000000000000000000000',
  `amountMoney` int(11) NOT NULL DEFAULT 0,
  `transactions` longtext DEFAULT NULL,
  `courant` tinyint(1) NOT NULL DEFAULT 0,
  `card_infos` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `bankaccounts`
--

INSERT INTO `bankaccounts` (`id`, `owner`, `owner_name`, `iban`, `amountMoney`, `transactions`, `courant`, `card_infos`) VALUES
(55, 'license:9aee5b5fed69441fa643f9db5ff2ddc5057745f0', 'Altix Altix', 'OFFI0MF14G0583748XJ07FS0916K', 0, '[{\"amount\":\"1000\",\"type\":\"Dépôt\",\"message\":\"Ajout de 1000$\",\"date\":\"09/05/2022 00:12:23\"},{\"amount\":\"1000\",\"type\":\"Retrait\",\"message\":\"Retrait de 1000$\",\"date\":\"09/05/2022 00:12:28\"},{\"amount\":\"+14\",\"type\":\"Dépôt\",\"message\":\"Ajout de +14$\",\"date\":\"09/05/2022 00:13:09\"},{\"amount\":\"+15\",\"type\":\"Dépôt\",\"message\":\"Ajout de +15$\",\"date\":\"09/05/2022 00:13:14\"},{\"amount\":\"29\",\"type\":\"Dépôt\",\"message\":\"Ajout de 29$\",\"date\":\"09/05/2022 00:13:18\"},{\"amount\":\"58\",\"type\":\"Retrait\",\"message\":\"Retrait de 58$\",\"date\":\"09/05/2022 00:13:20\"}]', 0, '{\"card_pin\":\"4770\",\"card_type\":\"Mastercard\",\"card_number\":\"3239196979605990\",\"card_cvv\":224,\"card_account\":55,\"card_expiration_date\":\"10/2028\",\"owner_name\":\"Altix Altix\"}'),
(58, 'license:a32f25553f22215bd8f6bc3402b039dcf8c5386d', 'Bryan Murphy', 'OFF039Q22C05J29X67MUINXL6QT3', 500, '[{\"date\":\"15/05/2022 13:40:13\",\"message\":\"Ajout de 500$\",\"type\":\"Dépôt\",\"amount\":\"500\"}]', 1, '{\"owner_name\":\"Bryan Murphy\",\"card_pin\":\"7927\",\"card_cvv\":500,\"card_type\":\"Mastercard\",\"card_number\":\"5434060298757707\",\"card_expiration_date\":\"10/2022\",\"card_account\":58}');

-- --------------------------------------------------------

--
-- Structure de la table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `discordId` varchar(255) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `group` varchar(250) NOT NULL DEFAULT 'user',
  `money` longtext NOT NULL DEFAULT '{"cash":0,"dirty":0}',
  `skin` longtext DEFAULT NULL,
  `characterInfos` longtext DEFAULT NULL,
  `coords` longtext DEFAULT NULL,
  `inventory` longtext NOT NULL DEFAULT '[]',
  `health` int(11) NOT NULL DEFAULT 200,
  `status` longtext NOT NULL DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `players`
--

INSERT INTO `players` (`id`, `identifier`, `discordId`, `token`, `group`, `money`, `skin`, `characterInfos`, `coords`, `inventory`, `health`, `status`) VALUES
(27, 'license:a32f25553f22215bd8f6bc3402b039dcf8c5386d', 'discord:396266406272040960', '5:97b597c8cd6cf1f90dc914bb17cf0ee24093dd86904495b205a64e934b6bb146', 'dev', '{\"cash\":889.0,\"dirty\":0}', '{\"bproof_2\":0,\"beard_1\":0,\"nose_5\":0.0,\"torso_2\":0,\"moles_2\":0,\"age_1\":0,\"dad\":41,\"nose_6\":0.0,\"lipstick_4\":0,\"beard_3\":0,\"chin_hole\":0.0,\"eyebrows_2\":0,\"decals_2\":0,\"chest_3\":0,\"torso_1\":15,\"eyebrows_3\":0,\"jaw_1\":0.0,\"decals_1\":0,\"hair_color_2\":0,\"chin_lenght\":0.0,\"makeup_3\":0,\"tshirt_1\":15,\"bodyb_1\":0,\"face_ped\":0,\"ears_1\":-1,\"moles_1\":0,\"blemishes_1\":0,\"jaw_2\":0.0,\"chest_1\":0,\"ears_2\":0,\"eyebrows_4\":0,\"makeup_1\":0,\"chin_height\":0.0,\"complexion_1\":0,\"chain_1\":0,\"chin_width\":0.0,\"bags_1\":0,\"hair_2\":0,\"chest_2\":0,\"glasses_2\":0,\"sun_2\":0,\"hair_color_1\":0,\"helmet_1\":-1,\"skin\":0.0,\"blemishes_2\":0,\"mask_1\":0,\"sun_1\":0,\"lipstick_3\":0,\"cheeks_3\":0.0,\"eyebrows_5\":0.0,\"mask_2\":0,\"bags_2\":0,\"neck_thick\":0.0,\"nose_1\":0.0,\"beard_4\":0,\"arms\":15,\"hair_1\":0,\"complexion_2\":0,\"shoes_2\":0,\"arms_2\":0,\"makeup_2\":0,\"eye_color\":0,\"cheeks_2\":0.0,\"blush_1\":0,\"bproof_1\":0,\"lipstick_1\":0,\"helmet_2\":0,\"shoes_1\":34,\"nose_2\":0.0,\"mom\":20,\"watches_2\":0,\"sex\":0,\"chain_2\":0,\"pants_1\":14,\"lips_thick\":0.0,\"tshirt_2\":0,\"eyebrows_6\":0.0,\"cheeks_1\":0.0,\"bracelets_2\":0,\"eyebrows_1\":0,\"age_2\":0,\"nose_3\":0.0,\"pants_2\":0,\"lipstick_2\":0,\"bracelets_1\":-1,\"watches_1\":-1,\"eye_open\":0.0,\"bodyb_2\":0,\"beard_2\":0,\"glasses_1\":-1,\"nose_4\":0.0,\"makeup_4\":0,\"blush_2\":0,\"face_ped2\":0,\"blush_3\":0,\"face\":0.0}', '{\"NDF\":\"Murphy\",\"LDN\":\"LS\",\"DDN\":\"03/11/1996\",\"Taille\":180,\"Sexe\":\"M\",\"Prenom\":\"Bryan\"}', '{\"x\":-1101.6263427734376,\"y\":2710.4306640625,\"z\":19.1025390625}', '[{\"count\":5,\"label\":\"BurgerShot MaxiBeef\",\"name\":\"burger\"},{\"count\":6,\"label\":\"Sprunk 33cl\",\"name\":\"sprunk\"},{\"label\":\"Pantalon 0\",\"name\":\"pants\",\"data\":[0,5],\"uniqueId\":\"588798012227517659652566413\",\"count\":1},{\"label\":\"Chaussure 4\",\"name\":\"shoes\",\"data\":[4,0],\"uniqueId\":\"782863240197469393089112567\",\"count\":1},{\"label\":\"Bryan Murphy\",\"name\":\"idcard\",\"data\":{\"Sexe\":\"M\",\"NDF\":\"Murphy\",\"LDN\":\"LS\",\"Prenom\":\"Bryan\",\"Taille\":180,\"DDN\":\"03/11/1996\"},\"uniqueId\":\"542227602727602700627458018\",\"count\":1},{\"label\":\"Compte n°58\",\"name\":\"carte\",\"data\":{\"card_number\":\"5434060298757707\",\"card_type\":\"Mastercard\",\"card_pin\":\"7927\",\"card_cvv\":500,\"card_expiration_date\":\"10/2022\",\"card_account\":58,\"owner_name\":\"Bryan Murphy\"},\"uniqueId\":\"646346122657617915673370073\",\"count\":1},{\"label\":\"Pantalon 0\",\"name\":\"pants\",\"data\":[0,5],\"uniqueId\":\"534718387037476256299646439\",\"count\":1}]', 200, '{}'),
(29, 'license:9aee5b5fed69441fa643f9db5ff2ddc5057745f0', 'discord:728208327942733865', '4:18a9c86ebdf832416aec68fa07e7034d645dfcb3e1994dfc5ac0c34e9640e929', 'dev', '{\"dirty\":0,\"cash\":1495.0}', '{\"makeup_2\":0,\"ears_2\":0,\"decals_1\":0,\"decals_2\":0,\"lips_thick\":0.0,\"bodyb_1\":0,\"chest_2\":0.0,\"lipstick_4\":0,\"pants_1\":14,\"nose_3\":0.0,\"cheeks_1\":0.0,\"helmet_1\":-1,\"lipstick_2\":0,\"complexion_2\":0,\"chin_lenght\":0.0,\"makeup_1\":0,\"neck_thick\":0.0,\"hair_color_1\":0,\"beard_1\":3,\"makeup_3\":0,\"blush_1\":0,\"eye_color\":5,\"bproof_2\":0,\"chain_2\":0,\"moles_1\":0,\"age_2\":0,\"cheeks_3\":0.0,\"tshirt_2\":0,\"bproof_1\":0,\"bags_2\":0,\"eyebrows_4\":0,\"glasses_2\":0,\"lipstick_3\":0,\"nose_4\":0.0,\"nose_6\":0.0,\"jaw_1\":0.0,\"chest_3\":0,\"shoes_2\":0,\"watches_1\":-1,\"bodyb_2\":0,\"watches_2\":0,\"sun_1\":0,\"age_1\":0,\"glasses_1\":-1,\"lipstick_1\":0,\"face\":0.51999999999999,\"torso_1\":15,\"skin\":0.0,\"arms_2\":0,\"jaw_2\":0.0,\"sex\":0,\"tshirt_1\":15,\"bracelets_1\":-1,\"face_ped\":0,\"moles_2\":0,\"hair_2\":0,\"mom\":31,\"eye_open\":0.0,\"dad\":23,\"chin_height\":0.0,\"shoes_1\":34,\"bags_1\":0,\"eyebrows_6\":0.0,\"chin_hole\":0.0,\"eyebrows_3\":0,\"nose_2\":0.0,\"arms\":15,\"sun_2\":0,\"nose_5\":0.0,\"beard_2\":10.0,\"pants_2\":0,\"beard_3\":0,\"hair_color_2\":0,\"hair_1\":24,\"chest_1\":0,\"blemishes_2\":0,\"makeup_4\":0,\"cheeks_2\":0.0,\"blush_3\":0,\"mask_2\":0,\"beard_4\":0,\"ears_1\":-1,\"helmet_2\":0,\"complexion_1\":0,\"torso_2\":0,\"blush_2\":0,\"face_ped2\":0,\"chain_1\":0,\"chin_width\":0.0,\"nose_1\":0.0,\"blemishes_1\":0,\"mask_1\":0,\"eyebrows_5\":0.0,\"bracelets_2\":0,\"eyebrows_2\":10.0,\"eyebrows_1\":1}', '{\"Taille\":178,\"DDN\":\"19/04/1999\",\"Sexe\":\"M\",\"Prenom\":\"Altix\",\"LDN\":\"LS\",\"NDF\":\"Altix\"}', NULL, '[{\"label\":\"BurgerShot MaxiBeef\",\"name\":\"burger\",\"count\":5},{\"label\":\"Sprunk 33cl\",\"name\":\"sprunk\",\"count\":5},{\"label\":\"Pantalon 9\",\"count\":1,\"name\":\"pants\",\"data\":[9,2],\"uniqueId\":\"945505928067659653866364855\"},{\"label\":\"Chaussure 7\",\"count\":1,\"name\":\"shoes\",\"data\":[7,0],\"uniqueId\":\"248475402545291827883676019\"}]', 200, '{}');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `bankaccounts`
--
ALTER TABLE `bankaccounts`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `bankaccounts`
--
ALTER TABLE `bankaccounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT pour la table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
