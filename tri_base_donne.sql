create table coaches(
	coach_id int auto_increment primary key,
	first_name varchar(50) not null,
	last_name  varchar(50) not null,
	specialization varchar(100),
	email varchar(100) unique,
	hire_date date
);


create table members(
	member_id int auto_increment primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(100) unique,
	phone varchar(20),
	registration_date DATE
);


create table activities(
	activity_id int auto_increment primary key,
	activity_name varchar(100) not null,
	coach_id int not null,
	day_of_week varchar(20),
	start_time time,
	max_participants int,
	price decimal(6,2),
	foreign key (coach_id) references coaches(coach_id)
);


create table registrations(
	registration_id int auto_increment primary key,
	member_id int not null,
	activity_id int not null,
	registration_date date,
	foreign key (member_id) references members(member_id),
	foreign key (activity_id) references activities(activity_id)
);

INSERT INTO coaches (first_name, last_name, specialization, email, hire_date) VALUES
('Sophie', 'Martin', 'Yoga', 'sophie.martin@club.com', '2023-05-10'),
('Franklin', 'Saint', 'Fitness', 'franklin.saint@club.com', '2024-06-04'),
('Brulux', 'Ontheflux', 'Football', 'brulux.flux@club.com', '2025-01-01');

INSERT INTO members (first_name, last_name, email, phone, registration_date) VALUES
('Jean', 'Dupont', 'jean.dupont@email.com', '0612345678', '2021-01-15'),
('Marge', 'Simson', 'marge.simson@email.com', '0766104237', '2022-03-23'),
('Billy', 'Redface', 'billy.red@email.com', '0676135478', '2023-04-14'),
('David', 'Diop', 'david.diop@email.com', '0682326778', '2024-04-14'),
('Aymen', 'François', 'aymen.françois@email.com', '076545678', '2025-06-06'),
('Hakim', 'Ziyech', 'hakim.ziyech@email.com', '072389678', '2025-08-16');

INSERT INTO activities (activity_name, coach_id, day_of_week, start_time, max_participants, price) VALUES
('Yoga', 1, 'Lundi', '18:00:00', 15, 25.00),
('Fitness', 2, 'Mardi', '19:00:00', 20, 30.00),
('Football', 3, 'Jeudi', '21:00:00', 25, 100.00),
('Street_workout', 2, 'Samedi', '14:00:00', 10, 25.00),
('Rugby', 3, 'Mercredi', '19:00:00', 20, 200.00);

INSERT INTO registrations (member_id, activity_id, registration_date) VALUES
(1, 1, '2024-09-01'),
(1, 2, '2024-09-02'), 
(2, 1, '2024-09-03'),
(3, 3, '2023-10-12'),
(5, 4, '2025-07-20'),
(6, 3, '2025-08-25'),
(6, 5, '2025-08-25'),
(5, 3, '2025-08-25'),
(1, 3, '2024-09-01');

-- Exercice 2: Modification.
-- Update.
-- Augmentez le prix de toutes les activités de 5€.
UPDATE activities
SET price = price + 5;
SELECT * FROM activities;

-- Delete.
-- Supprimez un membre qui n'a aucune inscription.

INSERT INTO members (first_name, last_name, email, phone, registration_date) VALUES
('Pierre', 'Jacques', 'pierre@email.com', '061234858', null);
delete from members
where registration_date is null;
select * from members;

-- Exercice 3:  Requêtes SELECT simples.
-- Question 1: Affichez tous les membres triés par nom de famille. 

select * from members
order by last_name;

-- Question 2: Listez toutes les activités qui coûtent moins de 35€ (après l'augmentation).

select * from activities 
where price < 35.00;

-- Question 3: Affichez le nom complet (prénom + nom) et l'email de tous les membres.

select concat(first_name,' ', last_name) as fullname, email from members;

-- Question 4: Listez tous les coaches avec leur spécialisation, triés par date d'embauche (du plus ancien au plus récent).

select concat(first_name,' ', last_name) as coach_fullname, specialization, hire_date from coaches
order by hire_date asc;

-- Question 5: Trouvez toutes les activités qui ont lieu le 'Lundi' ou le 'Mercredi'.

select * from activities
where day_of_week = 'Lundi' or day_of_week = 'Mercredi';

-- Exercice 4: Jointures et agrégation.
-- Question 6 : Affichez **toutes les activités** avec le nom complet de leur coach.
-- **Utilisez INNER JOIN** pour joindre `activities` et `coaches`.

select activity_name, concat(first_name,' ', last_name) as full_name from coaches
inner join activities using (coach_id);

-- Question 7: Affichez **toutes les inscriptions** avec :
-- Le nom complet du membre
-- Le nom de l'activité
-- Le nom complet du coach de l'activité
-- La date d'inscription

select 
	concat(m.first_name,' ', m.last_name) as fullname_member, 
    activity_name, 
	concat(c.first_name,' ', c.last_name) as fullname_coach, 
    r.registration_date 
from registrations r
inner join members m using (member_id)
inner join activities using (activity_id)
inner join coaches c using (coach_id);

-- Question 8: Comptez le **nombre d'inscrits** par activité. Affichez :
-- Le nom de l'activité
-- Le nombre de participants inscrits
-- **Utilisez GROUP BY + COUNT**

select activity_name, count(member_id) as count_members from activities
join registrations using (activity_id)
group by activity_name;

-- Question 9: Calculez le **revenu total potentiel** par coach (en supposant que toutes les activités sont pleines).
-- Affichez :
-- Le nom complet du coach
-- Le revenu total (somme des prix de ses activités × max_participants)
-- **Utilisez GROUP BY + SUM

select 
	concat(first_name,' ', last_name) as coach_fullname, 
    sum(a.price * a.max_participants) as revenue_total 
from coaches
join activities a using (coach_id)
group by coach_fullname;

-- Exercice 5 : Requêtes avancées.
-- Question 10: listez TOUS les coaches avec le nombre d'activités qu'ils encadrent (y compris ceux qui n'ont aucune activité).
-- **Utilisez LEFT JOIN + GROUP BY**

select 
	concat(first_name,' ', last_name) as coach_fullname, 
    count(activity_name) as nombre_activité_encadré 
from coaches
left join activities using (coach_id)
group by coach_fullname;

-- Question 11: Trouvez les activités qui ont PLUS de 3 inscrits.
-- Affichez :
-- Le nom de l'activité
-- Le nombre d'inscrits
-- **Utilisez GROUP BY + HAVING**

select activity_name, count(member_id) as count_members
from members
inner join registrations using (member_id)
inner join activities using (activity_id)
group by activity_name
having count(member_id) > 3;

-- Bonus 1: Identifiez les types de relations dans cette base de données :

-- a) Entre `coaches` et `activities` :
-- [ ] A. Un à un (1:1)
-- [X] B. Un à plusieurs (1:N): Car un coach peut avoir plusieurs activités et une activité peut avoir qu'un coach
-- [ ] C. Plusieurs à plusieurs (N:M)

-- b) Entre `members` et `activities` :
-- [ ] A. Un à un (1:1)
-- [ ] B. Un à plusieurs (1:N)
-- [X] C. Plusieurs à plusieurs (N:M): Car un membre peut avoir plusieurs activités et une activité peut avoir plusieurs membre

-- Bonus 2: Trouvez le coach qui a le plus d'activités. Affichez :
-- Le nom complet du coach
-- Le nombre d'activités
-- Sa spécialisation
-- Utilisez GROUP BY + ORDER BY + LIMIT**

select 
	concat(c.first_name,' ', c.last_name) as coach_fullname, 
	count(activity_name) as count_activities,
    c.specialization
from coaches c
left join activities using (coach_id)
group by coach_fullname, c.specialization
order by count(activity_name) desc
limit 1;

