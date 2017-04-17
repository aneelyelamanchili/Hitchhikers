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
    `Date/Time` VARCHAR(50) NOT NULL,
    `Detours` VARCHAR(50) NOT NULL,
    `Hospitality` VARCHAR(100) NOT NULL,
    `Food` VARCHAR(100) NOT NULL,
    `Luggage` VARCHAR(100) NOT NULL,
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
    `Date/Time` VARCHAR(50) NOT NULL,
    `Detours` VARCHAR(50) NOT NULL,
    `Hospitality` VARCHAR(100) NOT NULL,
    `Food` VARCHAR(100) NOT NULL,
    `Luggage` VARCHAR(100) NOT NULL,
    `TotalSeats` INT(11) NOT NULL,
    `SeatsAvailable` INT(11) NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`),
    PRIMARY KEY(`rideID`) 
);

INSERT INTO `TotalUsers` (FirstName, LastName, Password, Email, `Age`, `PhoneNumber`, `Picture`) VALUES ('Aneel', 'Yelamanchili', 'babu', 'aneel@usc.edu', 20, '5039169169', 'http://cdn.playbuzz.com/cdn/68b5fdf9-f35e-4632-8775-ac843caaf4ee/a9c30fe4-915f-4b0a-902f-edf35814d086.jpg');
INSERT INTO `TotalUsers` (FirstName, LastName, Password, Email, `Age`, `PhoneNumber`, `Picture`) VALUES ('David', 'Sealand', 'password', 'sealand@usc.edu', 19, '4919193020', 'https://s-media-cache-ak0.pinimg.com/originals/21/54/3a/21543a3fb441a221b2e5444c19bcc23b--funny-animal-pictures-funny-animals.jpg');
INSERT INTO `TotalUsers` (FirstName, LastName, Password, Email, `Age`, `PhoneNumber`, `Picture`) VALUES ('Adam', 'Espinoza', 'mypassword', 'adamespi@usc.edu', 20, '9101223112', 'https://cdn1.pri.org/sites/default/files/styles/story_main/public/story/images/One-of-the-photos-taken-b-013.jpg?itok=sAUB2EBU');
INSERT INTO `TotalPreviousTrips`( rideID, userID,FirstName, LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsFilled) VALUES (1,1,'Adam','Espinoza', 'adamespi@usc.edu','San Fracisco,CA', 'Los Angeles', 'Honda Civic' , '64j74k', 25, 'jlksjdf', 'no detours', 'gimme a pillow', 'i have snaks', 'no space', 4, 2);
INSERT INTO `CurrentTrips`( userID,FirstName,LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES (1,'Adam','Espinoza', 'adamespi@usc.edu','1816 NW 127th Pl, Portland, OR', '22 SW 3rd Ave, Portland, OR 97204, USA', 'Bugatti Veyron' , '309EAK', 10, '4:20AM', 'no detours', 'gimme a pillow', 'i have snaks', 'no space', 4, 3);
INSERT INTO `CurrentTrips`( userID,FirstName,LastName,Email,StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES (1,'Adam','Espinoza', 'aneel@usc.edu','1816 NW 127th Pl, Portland, OR', '1237 SW Washington St, Portland, OR 97205, USA', 'Bugatti Veyron' , '309EAK', 10, '4:20AM', 'all the detours', 'ughhhhh hospitality', 'i got food tho', 'bring ur house',4,3);

/*SELECT u.Username FROM `TotalPreviousTrips` t, `TotalUsers` u 
WHERE t.userID = u.userID */
