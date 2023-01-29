USE BankSystem
 
INSERT INTO Banks (Name)
VALUES
(N'Belarus Bank'), (N'MTBank'), (N'Alpha-Bank'), (N'Sber Bank'), (N'BelinvestBank');

INSERT INTO Cities (Name)
VALUES
(N'Minsk'), (N'Gomel'), (N'Vitebsk'), (N'Mogilev'), (N'Brest'), (N'Grodno');

INSERT INTO BranchOffices (Name, CityId, BankId)
VALUES
(N'Филиал №1', 1, 1), (N'Филиал №3', 2, 1), (N'Филиал №5', 3, 1), (N'Филиал №8', 4, 1), (N'Филиал №11', 5, 1), (N'Филиал №14', 6, 1),
(N'Филиал №2', 1, 2), (N'Филиал №6', 2, 2), (N'Филиал №9', 3, 2), (N'Филиал №10', 4, 2),
(N'Филиал №1', 1, 3), (N'Филиал №2', 2, 3),
(N'Филиал №1', 1, 4), (N'Филиал №8', 2, 4), (N'Филиал №9', 3, 4), (N'Филиал №10', 4, 4), (N'Филиал №11', 5, 4),
(N'Филиал №1', 1, 5), (N'Филиал №3', 2, 5), (N'Филиал №4', 3, 5), (N'Филиал №9', 4, 5), (N'Филиал №12', 5, 5), (N'Филиал №16', 6, 5);

INSERT INTO SocialStatuses (Name)
VALUES
(N'Наёмный работник'), (N'Безработный'), (N'Владелец бизнеса и ИП'), (N'Пенсионер'), (N'Льготная категория'), (N'Студент'), (N'Домохозяйка, -ин'), (N'В декретном отпуске');

INSERT INTO Clients (Name, Phone, SocialStatusId)
VALUES
(N'Меркушев Мечислав Ильяович', N'+0 00 0000000', 3),
(N'Потапов Давид Фролович', N'+0 00 0000001', 4),
(N'Шаров Герасим Артёмович', N'+0 00 0000002', 5),
(N'Фомичёва Надежда Иринеевна', N'+0 00 0000003', 2),
(N'Волкова Романа Иринеевна', N'+0 00 0000004', 7),
(N'Кондратьев Пантелеймон Павлович', N'+0 00 0000005', 3),
(N'Быков Харитон Филиппович', N'+0 00 0000006', 1);
 
INSERT INTO BankClients (BankId, ClientId, AccountBalance)
VALUES
(1, 1, 1000), (2, 2, 0), (3, 3, 200), (4, 4, 10), (5, 5, 100.1234), (2, 6, 5000), (4, 7, 2500.2033)

 INSERT INTO BankCards (BankClientId, CardBalance)
 VALUES
 (1, 200), (1, 300), (2, 0), (2, 0), (2, 0), (5, 50.1234), (6, 1250), (6, 750.5), (7, 2000.2033), (7, 500.0);