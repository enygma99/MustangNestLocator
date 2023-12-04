INSERT INTO Apartment (Name, Location, Rent, Bedrooms, Bathrooms, Latitude, Longitude, ContactName, ContactNumber) VALUES 
('Village Gate', 'Village', 2500, 2, 2, 32.858937, -96.765563, 'Dev Mukherjee', '469-456-7911'),
('Village Gate', 'Village', 1480, 1, 1, 32.858937, -96.765789, 'John Smith', '214-555-1234'),
('Village Gate', 'Village', 2100, 2, 1, 32.858937, -96.765144, 'Emily Johnson', '972-789-4561'),
('Village Green', 'Village', 4720, 3, 3, 32.852563, -96.762812, 'Michael Davis', '817-123-7890'),
('Village Green', 'Village', 3690, 3, 2, 32.852563, -96.762628, 'Sophia Brown', '682-555-9876'),
('SMU Apartments', 'On Campus', 980, 1, 1, 32.844687, -96.804063, 'Jason Bateman', '682-726-6120'),
('SMU Apartments', 'On Campus', 1030, 1, 1, 32.844693, -96.804155, 'Jason Bateman', '682-726-6120'),
('SMU Apartments', 'On Campus', 1120, 1, 1, 32.8446871, -96.804267, 'Jason Bateman', '682-726-6120'),
('SMU Apartments', 'On Campus', 945, 1, 1, 32.844166, -96.804483, 'Jason Bateman', '682-726-6120'),
('SMU Apartments', 'On Campus', 1010, 1, 1, 32.844948, -96.804043, 'Jason Bateman', '682-726-6120'),
('SMU Apartments', 'On Campus', 990, 1, 1, 32.844787, -96.804763, 'Jason Bateman', '682-726-6120')
;

INSERT INTO Apartment (Name, Location, Rent, Bedrooms, Bathrooms, Latitude, Longitude, ContactName, ContactNumber) VALUES 
('Village Chase', 'Village', 2900, 2, 2, 32.856687, -96.766437, 'Roshan Dhaigude', '469-456-7911'),
('Village Chase', 'Village', 2780, 2, 1, 32.856187, -96.766637, 'Rahul Jogdhankar', '214-555-1234'),
('Village Chase', 'Village', 2100, 2, 1, 32.856987, -96.766137, 'James Bond', '972-789-4561'),
('Village Green', 'Village', 4720, 3, 3, 32.852763, -96.762412, 'Jyoti Singh', '817-123-7890'),
('Village Green', 'Village', 3690, 3, 2, 32.852168, -96.762098, 'Gabriela Rodriguez', '682-555-9876')
;

INSERT INTO Apartment (Name, Location, Rent, Bedrooms, Bathrooms, Latitude, Longitude, ContactName, ContactNumber) VALUES 
('Achieve', 'Arrive on University', 1480, 1, 1, 32.844313, -96.768687, 'Emma Watson', '469-456-7911'),
('Motivate', 'Arrive on University', 1780, 2, 1, 32.844619, -96.768193, 'Tom Holland', '214-555-1234'),
('Excel', 'Arrive on University', 2200, 2, 1, 32.844201, -96.768428, 'Phil Dunphy', '817-123-7890'),
('Excel', 'Arrive on University', 2120, 2, 1, 32.844006, -96.768772, 'Phil Dunphy', '817-123-7890'),
('Motivate', 'Arrive on University', 1690, 2, 1, 32.844499, -96.768069, 'Chloe Blaise', '682-555-9876')
;

INSERT INTO UserTable (Username, Password, Name, Phone)
VALUES 
  ('john_doe', 'password123', 'John Doe', '123-456-7890'),
  ('jane_smith', 'pass456', 'Jane Smith', '987-654-3210'),
  ('bob_jones', 'securePwd', 'Bob Jones', '555-123-4567'),
  ('alice_smith', 'pass789', 'Alice Smith', '111-222-3333'),
  ('mark_johnson', 'secret123', 'Mark Johnson', '444-555-6666'),
  ('susan_white', 'susanPwd', 'Susan White', '777-888-9999'),
  ('david_green', 'green123', 'David Green', '999-888-7777'),
  ('emily_davis', 'emilyPwd', 'Emily Davis', '333-222-1111'),
  ('samuel_brown', 'sam123', 'Samuel Brown', '123-987-4567'),
  ('lisa_miller', 'lisaPwd', 'Lisa Miller', '987-654-3210'),
  ('kevin_jackson', 'kevin456', 'Kevin Jackson', '555-111-7777'),
  ('natalie_wilson', 'nataliePwd', 'Natalie Wilson', '888-444-2222'),
  ('robert_anderson', 'rob123', 'Robert Anderson', '777-333-8888'),
  ('olivia_clark', 'oliviaPwd', 'Olivia Clark', '444-222-5555'),
  ('daniel_harris', 'daniel456', 'Daniel Harris', '111-666-9999'),
  ('sophia_moore', 'sophiaPwd', 'Sophia Moore', '666-888-3333'),
  ('brian_martin', 'brian123', 'Brian Martin', '999-111-5555'),
  ('amber_carter', 'amberPwd', 'Amber Carter', '222-444-6666')
;

INSERT INTO Review (UserID, ApartmentID, Rating, Comment, Date)
VALUES 
  (3, 76, 4.0, 'Good amenities.', '2023-03-05'),
  (8, 79, 3.5, 'Quiet neighborhood.', '2023-03-12'),
  (15, 88, 4.8, 'Excellent view!', '2023-04-01'),
  (6, 81, 3.2, 'Could be cleaner.', '2023-04-15'),
  (12, 94, 4.5, 'Responsive management.', '2023-05-02'),
  (18, 97, 3.7, 'Affordable rent.', '2023-05-10'),
  (2, 74, 4.2, 'Close to public transport.', '2023-06-01'),
  (9, 82, 3.9, 'Friendly neighbors.', '2023-06-15'),
  (16, 80, 4.6, 'Well-maintained property.', '2023-07-01'),
  (4, 96, 3.0, 'Needs renovation.', '2023-07-10')
;

INSERT INTO Review (UserID, ApartmentID, Rating, Comment, Date) VALUES (9, 78, 5, 'Amazing', '2023-03-05');