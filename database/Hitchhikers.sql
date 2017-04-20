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
    `PhoneNumber` VARCHAR(20) NOT NULL,
    `Picture` VARCHAR(200) NOT NULL,
    PRIMARY KEY(`userID`) 
);

CREATE TABLE `TotalPreviousTrips` (
	`rideID` INT(11) NOT NULL,
	`userID` INT(11) NOT NULL,
	`FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Email` VARCHAR(50) NOT NULL,
    `StartingPoint` VARCHAR(200) NOT NULL,
    `DestinationPoint` VARCHAR(200) NOT NULL, 
    `CarModel` VARCHAR(50) NOT NULL,
    `LicensePlate` VARCHAR(50) NOT NULL,
    `Cost` INT(11) NOT NULL, 
    `Date/Time` VARCHAR(100) NOT NULL,
    `Detours` VARCHAR(200) NOT NULL,
    `Hospitality` VARCHAR(200) NOT NULL,
    `Food` VARCHAR(200) NOT NULL,
    `Luggage` VARCHAR(200) NOT NULL,
    `TotalSeats` INT(11) NOT NULL,
    `SeatsFilled` INT(11) NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`)
);

CREATE TABLE `CurrentTrips` (
	`rideID` INT(11) auto_increment NOT NULL,
	`userID` INT(11) NOT NULL,
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Email` VARCHAR(50) NOT NULL,
    `StartingPoint` VARCHAR(200) NOT NULL,
    `DestinationPoint` VARCHAR(200) NOT NULL, 
    `CarModel` VARCHAR(50) NOT NULL,
    `LicensePlate` VARCHAR(50) NOT NULL,
    `Cost` INT(11) NOT NULL, 
    `Date/Time` VARCHAR(100) NOT NULL,
    `Detours` VARCHAR(200) NOT NULL,
    `Hospitality` VARCHAR(200) NOT NULL,
    `Food` VARCHAR(200) NOT NULL,
    `Luggage` VARCHAR(200) NOT NULL,
    `TotalSeats` INT(11) NOT NULL,
    `SeatsAvailable` INT(11) NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`),
    PRIMARY KEY(`rideID`) 
);

INSERT INTO `TotalUsers` (FirstName, LastName, Password, Email, `Age`, `PhoneNumber`, `Picture`) VALUES ('Aneel', 'Yelamanchili', 'aneel', 'ayelaman@usc.edu', 20, '5039169169', 'https://scontent-lax3-2.xx.fbcdn.net/v/t1.0-9/13507226_1148683701850248_1676098310529753614_n.jpg?oh=8fc80ae2dd67fa09b7b8e40c801c8130&oe=5951E6F9');
INSERT INTO `TotalUsers` (FirstName, LastName, Password, Email, `Age`, `PhoneNumber`, `Picture`) VALUES ('David', 'Sealand', 'david', 'sealand@usc.edu', 19, '4919193020', 'https://scontent-lax3-2.xx.fbcdn.net/v/t31.0-8/12841330_663274557146113_2810161329870379623_o.jpg?oh=98a2db28fbd7e4df98aaa19f3f6c9bc6&oe=59958317');
INSERT INTO `TotalUsers` (FirstName, LastName, Password, Email, `Age`, `PhoneNumber`, `Picture`) VALUES ('Adam', 'Espinoza', 'adam', 'adamespi@usc.edu', 20, '9101223112', 'https://media.licdn.com/mpr/mpr/shrinknp_400_400/AAEAAQAAAAAAAAiDAAAAJDNiMWE3YTkyLTRiMzAtNDJkNS1hMjE3LWE2ZWFiNDlkMDgwNA.jpg');
INSERT INTO `TotalUsers` (FirstName, LastName, Password, Email, `Age`, `PhoneNumber`, `Picture`) VALUES ('William', 'Wang', 'william', 'wang975@usc.edu', 20, '8083219909', 'https://scontent-lax3-2.xx.fbcdn.net/v/t1.0-9/12122921_974493999258444_5174282398401993915_n.jpg?oh=33da5dee348b806e9d7554f9750a3a5b&oe=59961E92');
INSERT INTO `TotalPreviousTrips`( rideID, userID,FirstName, LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsFilled) VALUES (1,1,'Adam','Espinoza', 'adamespi@usc.edu','San Fracisco,CA', 'Los Angeles', 'Honda Civic' , '64j74k', 25, 'Wednesday April 19', 'no detours', 'bring pillows', 'i have snacks', 'no luggage space', 4, 2);
INSERT INTO `CurrentTrips`( userID,FirstName,LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES (2,'David','Sealand', 'sealand@usc.edu','Los Angeles, CA, USA', 'Portland, OR, USA', 'Bugatti Veyron' , '202JEJ', 20, 'Friday April 21', 'no detours', 'I love food', 'i have no snacks', 'lots of luggage space', 2, 1);
INSERT INTO `CurrentTrips`( userID,FirstName,LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES (3,'Adam','Espinoza', 'adamespi@usc.edu','Los Angeles, CA, USA', 'Phoenix, AZ, USA', 'Honda Odyssey' , '309EAK', 12, 'Saturday April 22', 'all the detours', 'You can stay with me', 'I will bring food', 'bring any luggage',6,5);
INSERT INTO `CurrentTrips`( userID,FirstName,LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES (1,'Aneel','Yelamanchili', 'ayelaman@usc.edu','Los Angeles, CA, USA', 'San Francisco, CA, USA', 'Nissan Leaf' , '857KZN', 15, 'Sunday April 23', 'no detours', 'We are stopping to charge 10 times', 'We will stop for food', 'bring any luggage',4,3);
