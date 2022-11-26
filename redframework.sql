-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : sam. 26 nov. 2022 à 11:32
-- Version du serveur : 10.4.25-MariaDB
-- Version de PHP : 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `redframework`
--

-- --------------------------------------------------------



--
-- Structure de la table `users`
--

CREATE TABLE `users` (
                         `id` int(11) NOT NULL,
                         `identifier` varchar(255) NOT NULL,
                         `rank` varchar(25) NOT NULL DEFAULT 'user',
                         `inventory` longtext NOT NULL DEFAULT '{}',
                         `cash` int(25) NOT NULL,
                         `bank` int(25) NOT NULL,
                         `skin` longtext NOT NULL DEFAULT '{"shoes_1":5,"bags_1":0,"tshirt_1":15,"bracelets_1":-1,"blush_3":0,"hair_color_1":0,"ears_2":0,"sex":0,"chest_3":0,"watches_1":-1,"chest_1":0,"eyebrows_3":0,"bodyb_2":0,"age_1":0,"hair_1":1,"blush_2":0,"face":0,"eye_color":0,"bproof_1":0,"torso_1":22,"torso_2":0,"mask_1":0,"complexion_1":0,"makeup_2":0,"decals_1":0,"lipstick_4":0,"lipstick_3":0,"lipstick_1":0,"makeup_3":0,"blush_1":0,"eyebrows_2":0,"bracelets_2":0,"lipstick_2":0,"skin":0,"chest_2":0,"helmet_1":-1,"beard_3":0,"sun_1":0,"chain_1":0,"pants_1":15,"glasses_1":0,"ears_1":-1,"moles_2":0,"mask_2":0,"bodyb_1":0,"pants_2":0,"glasses_2":0,"makeup_1":0,"blemishes_1":0,"makeup_4":0,"eyebrows_4":0,"complexion_2":0,"age_2":0,"bags_2":0,"bproof_2":0,"shoes_2":0,"hair_color_2":0,"beard_4":0,"hair_2":0,"beard_1":0,"watches_2":0,"sun_2":0,"eyebrows_1":0,"tshirt_2":0,"beard_2":0,"blemishes_2":0,"chain_2":0,"arms_2":0,"moles_1":0,"arms":0,"decals_2":0,"helmet_2":0}',
                         `job` varchar(25) NOT NULL,
                         `job_grade` varchar(25) NOT NULL,
                         `firstname` varchar(255) NOT NULL,
                         `lastname` varchar(255) NOT NULL,
                         `position` longtext NOT NULL DEFAULT '{"x":-269.4,"y":-955.3,"z":31.2,"heading":205.8}',
                         `licences` longtext NOT NULL DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `identifier`, `rank`, `inventory`, `cash`, `bank`, `skin`, `job`, `job_grade`, `firstname`, `lastname`, `position`, `licences`) VALUES
    (9, 'steam:1100001403b9b20', 'user', '{}', 0, 0, '{\"complexion_2\":0,\"hair_2\":0,\"arms\":0,\"eyebrows_2\":0,\"lipstick_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"ears_2\":0,\"blush_3\":0,\"torso_1\":22,\"skin\":0,\"mask_1\":0,\"makeup_4\":0,\"hair_color_1\":0,\"decals_2\":0,\"moles_1\":0,\"beard_2\":0,\"pants_2\":0,\"bodyb_2\":0,\"blush_2\":0,\"sun_1\":0,\"blemishes_2\":0,\"lipstick_2\":0,\"sun_2\":0,\"helmet_2\":0,\"bproof_2\":0,\"eyebrows_1\":0,\"pants_1\":15,\"blush_1\":0,\"beard_3\":0,\"shoes_2\":0,\"glasses_2\":0,\"tshirt_1\":15,\"chain_1\":0,\"face\":0,\"watches_1\":-1,\"age_2\":0,\"decals_1\":0,\"eye_color\":0,\"bags_1\":0,\"eyebrows_4\":0,\"torso_2\":0,\"watches_2\":0,\"lipstick_4\":0,\"moles_2\":0,\"ears_1\":-1,\"blemishes_1\":0,\"beard_1\":0,\"lipstick_1\":0,\"bags_2\":0,\"makeup_1\":0,\"chest_3\":0,\"hair_color_2\":0,\"shoes_1\":5,\"glasses_1\":0,\"beard_4\":0,\"eyebrows_3\":0,\"mask_2\":0,\"hair_1\":1,\"chest_1\":0,\"chain_2\":0,\"age_1\":0,\"arms_2\":0,\"bproof_1\":0,\"tshirt_2\":0,\"helmet_1\":-1,\"bracelets_2\":0,\"chest_2\":0,\"bodyb_1\":0,\"bracelets_1\":-1,\"complexion_1\":0,\"sex\":0}', 'unemployed', 'unemployed', '', '', '{\"x\":-269.4,\"y\":-955.3,\"z\":31.2,\"heading\":205.8}', '[]');

-- --------------------------------------------------------



--
-- Index pour les tables déchargées
--

--
-- Index pour la table `users`
--
ALTER TABLE `users`
    ADD PRIMARY KEY (`id`);



-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
