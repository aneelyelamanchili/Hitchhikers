
public class Constants {
	public static final String SQL_INSERT_USER = "INSERT INTO TotalUsers(Username, Password, Email, Age, PhoneNumber, Picture, isDriver) VALUES ";
	public static final String SQL_INSERT_RIDE = "INSERT INTO CurrentRides(userID, FirstName, LastName, Email, StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES";
	public static final String SQL_INSERT_PREVIOUSRIDE = "INSERT INTO TotalPreviousTrips(rideID, userID, FirstName, LastName, Email, StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsFilled) VALUES";
}
