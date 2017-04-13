DROP DATABASE if exists Hitchhikers;

CREATE DATABASE Hitchhikers; 

USE  Hitchhikers; 

/*
** Total Users of Hitchhikers
*/
CREATE TABLE `TotalUsers` (
	`userID` INT(11) auto_increment NOT NULL, 
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Password` VARCHAR(50) NOT NULL, 
    `Email` VARCHAR(50) NOT NULL, 
    `Age` INT(11) NOT NULL,
    `PhoneNumber` VARCHAR(50) NOT NULL,
    `Picture` VARCHAR(200) NOT NULL,
    `isDriver` TINYINT(1) DEFAULT '0' NOT NULL, 
    PRIMARY KEY(`userID`) 
);

CREATE TABLE `TotalPreviousTrips` (
	`rideID` INT(11) NOT NULL,
	`userID` INT(11) NOT NULL,
	`FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Email` VARCHAR(50) NOT NULL,
    `StartingPoint` VARCHAR(50) NOT NULL,
    `DestinationPoint` VARCHAR(50) NOT NULL, 
    `CarModel` VARCHAR(50) NOT NULL,
    `LicensePlate` VARCHAR(50) NOT NULL,
    `Cost` INT(11) NOT NULL, 
    `Date/Time` VARCHAR(50) NOT NULL,
    `Detours` VARCHAR(50) NOT NULL,
    `Hospitality` VARCHAR(100) NOT NULL,
    `Food` VARCHAR(50) NOT NULL,
    `Luggage` VARCHAR(50) NOT NULL,
    `TotalSeats` INT(11) NOT NULL,
    `SeatsFilled` INT(11) NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`),
	PRIMARY KEY(`rideID`) 
);

CREATE TABLE `CurrentTrips` (
	`rideID` INT(11) auto_increment NOT NULL,
	`userID` INT(11) NOT NULL,
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Email` VARCHAR(50) NOT NULL,
    `StartingPoint` VARCHAR(50) NOT NULL,
    `DestinationPoint` VARCHAR(50) NOT NULL, 
    `CarModel` VARCHAR(50) NOT NULL,
    `LicensePlate` VARCHAR(50) NOT NULL,
    `Cost` INT(11) NOT NULL, 
    `Date/Time` VARCHAR(50) NOT NULL,
    `Detours` VARCHAR(50) NOT NULL,
    `Hospitality` VARCHAR(100) NOT NULL,
    `Food` VARCHAR(50) NOT NULL,
    `Luggage` VARCHAR(50) NOT NULL,
    `TotalSeats` INT(11) NOT NULL,
    `SeatsAvailable` INT(11) NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`),
    PRIMARY KEY(`rideID`) 
);

INSERT INTO `TotalUsers`( FirstName, LastName, Password, Email, `Age` ,`PhoneNumber`, `Picture`,isDriver ) VALUES  ('Adam', 'Espinoza', 'mypassword', 'adamespi@usc.edu', 20, '6267560235', 'https://cdn1.pri.org/sites/default/files/styles/story_main/public/story/images/One-of-the-photos-taken-b-013.jpg?itok=sAUB2EBU', 1);
INSERT INTO `TotalPreviousTrips`( rideID, userID,FirstName, LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsFilled) VALUES (6,1,'Adam','Espinoza', 'adamespi@usc.edu','San Fracisco,CA', 'Los Angeles', 'Honda Civic' , '64j74k', 25, 'jlksjdf', 'no detours', 'gimme a pillow', 'i have snaks', 'no space', 4, 2);
INSERT INTO `CurrentTrips`( userID,FirstName,LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES (1,'Adam','Espinoza', 'adamespi@usc.edu','1816 NW 127th Pl, Portland, OR', 'Voodoo Doughnut', 'Bugatti Veyron' , '309EAK', 10, '4:20AM', 'no detours', 'gimme a pillow', 'i have snaks', 'no space', 4, 3);
INSERT INTO `CurrentTrips`( userID,FirstName,LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES (1,'Adam','Espinoza', 'adamespi@usc.edu','1816 NW 127th Pl, Portland, OR', 'Voodoo Doughnut', 'Bugatti Veyron' , '309EAK', 10, '4:20AM', 'all the detours', 'ughhhhh hospitality', 'i got food tho', 'bring ur house',4,3);

/*SELECT u.Username FROM `TotalPreviousTrips` t, `TotalUsers` u 
WHERE t.userID = u.userID */
