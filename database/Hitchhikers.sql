DROP DATABASE if exists Hitchhikers;

CREATE DATABASE Hitchhikers; 

USE  Hitchhikers; 

/*
** Total Users of Hitchhikers
*/
CREATE TABLE `TotalUsers` (
	`userID` INT(11) auto_increment NOT NULL, 
    `Username` VARCHAR(50) NOT NULL,
    `Password` VARCHAR(50) NOT NULL, 
    `Email` VARCHAR(50) NOT NULL, 
    `Age` INT(11) NOT NULL,
    `PhoneNumber` VARCHAR(50) NOT NULL,
    `Picture` VARCHAR(50) NOT NULL,
    `isDriver` TINYINT(4) DEFAULT '0' NOT NULL, 
    PRIMARY KEY(`userID`) 
);

CREATE TABLE `TotalPreviousTrips` (
	`userID` INT(11) NOT NULL,
    `StartingPoint` VARCHAR(50) NOT NULL,
    `DestinationPoint` VARCHAR(50) NOT NULL, 
    `CarModel` VARCHAR(50) NOT NULL,
    `LicensePlate` VARCHAR(50) NOT NULL,
    `Cost` INT(11) NOT NULL, 
    `Date/Time` VARCHAR(50) NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`)
);

INSERT INTO `TotalUsers`( Username, Password, Email, `Age` ,`PhoneNumber`, `Picture` ) VALUES  ('Adam', 'mypassword', 'adamespi@usc.edu', 20, '6267560235', 'swag.com');
INSERT INTO `TotalPreviousTrips`( userID,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`) VALUES (1,'San Fracisco,CA', 'Los Angeles', 'Honda Civic' , '64j74k', 25, 'jlksjdf');

/*SELECT u.Username FROM `TotalPreviousTrips` t, `TotalUsers` u 
WHERE t.userID = u.userID */
