CREATE TABLE UserTable (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Name VARCHAR(255),
    Phone VARCHAR(20)
);

CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES UserTable(UserID),
    ApartmentID INT FOREIGN KEY REFERENCES Apartment(ApartmentID),
    Rating FLOAT(10),
    Comment VARCHAR(255),
    Date DATE
);

CREATE TABLE Apartment (
    ApartmentID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255),
    Location VARCHAR(255),
    Rent INT,
    Bedrooms INT,
    Bathrooms INT,
    Latitude FLOAT,
    Longitude FLOAT
);


CREATE TABLE Amenity (
    ApartmentID INT PRIMARY KEY,
    SwimmingPool BIT,
    Gym BIT,
    ClubHouse BIT,
    TennisCourt BIT,
    FOREIGN KEY (ApartmentID) REFERENCES Apartment(ApartmentID)
);

ALTER TABLE Apartment
ADD ContactName VARCHAR(255),
    ContactNumber VARCHAR(20);

