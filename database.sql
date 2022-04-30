-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : dim. 24 avr. 2022 à 00:35
-- Version du serveur : 10.4.21-MariaDB
-- Version de PHP : 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `database`
--

-- --------------------------------------------------------

--
-- Structure de la table `bans`
--

CREATE TABLE `bans` (
  `id` int(11) NOT NULL,
  `bans` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `bans`
--

INSERT INTO `bans` (`id`, `bans`) VALUES
(1, '{}');

-- --------------------------------------------------------

--
-- Structure de la table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `inventory` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `inventory`
--

INSERT INTO `inventory` (`id`, `identifier`, `inventory`) VALUES
(1, 'license:9aee5b5fed69441fa643f9db5ff2ddc5057745f0', '[]');

-- --------------------------------------------------------

--
-- Structure de la table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `discordId` varchar(255) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `characterInfos` longtext DEFAULT NULL,
  `coords` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `players`
--

INSERT INTO `players` (`id`, `identifier`, `discordId`, `token`, `characterInfos`, `coords`) VALUES
(2, 'license:a32f25553f22215bd8f6bc3402b039dcf8c5386d', 'discord:396266406272040960', '4:68ded40c55588922d0d706785302baaf08838b0e1149892de8b915d6400efbb0', '[]', '{\"x\":9.61318778991699,\"y\":-83.5120849609375,\"z\":59.3062744140625}'),
(3, 'license:9aee5b5fed69441fa643f9db5ff2ddc5057745f0', 'discord:728208327942733865', '4:84fd2b85ba45b22eb283c2aa93f8078039c0753f26b8a9db63d82181b431b25d', '[]', '{\"x\":-74.46592712402344,\"y\":56.4131851196289,\"z\":71.741455078125}');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `inventory`
--
ALTER TABLE `inventory`
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
-- AUTO_INCREMENT pour la table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
