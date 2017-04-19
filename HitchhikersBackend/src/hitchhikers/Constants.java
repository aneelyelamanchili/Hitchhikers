package hitchhikers;

public class Constants {
	public static final String SQL_INSERT_USER = "INSERT INTO TotalUsers(FirstName, Lastname, Password, Email, Age, PhoneNumber, Picture) VALUES ";
	public static final String SQL_INSERT_RIDE = "INSERT INTO CurrentTrips(userID, FirstName, LastName, Email, StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES";
	public static final String SQL_INSERT_PREVIOUSRIDE = "INSERT INTO TotalPreviousTrips(rideID, userID, FirstName, LastName, Email, StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsFilled) VALUES";
}
