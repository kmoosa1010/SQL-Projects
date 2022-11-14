----querY to implement the sport database for a primary school

CREATE TABLE parent(
    parent_id CHAR(5),
    first_name VARCHAR2(20) NOT NULL,
    last_name VARCHAR2(20) NOT NULL,
    contact CHAR(10) NOT NULL,
    CONSTRAINT parent_parent_id_pk PRIMARY KEY(parent_id)
);

CREATE TABLE learner(
    learner_id CHAR(5),
    parent_id CHAR(5) NOT NULL,
    first_name VARCHAR2(20) NOT NULL,
    last_name VARCHAR2(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    CONSTRAINT learner_learner_id_pk PRIMARY KEY(learner_id),
    CONSTRAINT learner_parent_id_fk FOREIGN KEY(parent_id) REFERENCES parent(parent_id)
);

CREATE TABLE sport(
    sport_id CHAR(3),
    sport_name VARCHAR2(10),
    CONSTRAINT sport_sport_id_pk PRIMARY KEY(sport_id),
    CONSTRAINT sport_sport_name_ck CHECK(sport_name IN('Football','Netball','Athletics','Chess'))
);

CREATE TABLE registration(
    registration_id CHAR(5),
    learner_id CHAR(5),
    sport_id CHAR(3),
    registration_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT registration_registration_id_pk PRIMARY KEY(registration_id),
    CONSTRAINT registration_learner_id_fk FOREIGN KEY(learner_id) REFERENCES learner(learner_id),
    CONSTRAINT registration_sport_id_fk FOREIGN KEY(sport_id) REFERENCES sport(sport_id)
);

CREATE TABLE coach(
    coach_id CHAR(5),
    coach_fname VARCHAR2(20),
    coach_lname VARCHAR2(20),
    CONSTRAINT coach_coach_id_pk PRIMARY KEY(coach_id)
);

CREATE TABLE team(
    team_id CHAR(5),
    sport_id CHAR(3),
    coach_id CHAR(5),
    team_name VARCHAR2(15),
    CONSTRAINT team_team_id_pk PRIMARY KEY(team_id),
    CONSTRAINT team_sport_id_fk FOREIGN KEY(sport_id) REFERENCES sport(sport_id),
    CONSTRAINT team_coach_id_fk FOREIGN KEY(coach_id) REFERENCES coach(coach_id)
);

CREATE TABLE learnerTeam(
    learner_id CHAR(5),
    team_id CHAR(5),
    CONSTRAINT learnerTeam_learner_id_fk FOREIGN KEY(learner_id) REFERENCES learner(learner_id),
    CONSTRAINT learnerTeam_team_id_fk FOREIGN KEY(team_id) REFERENCES team(team_id)
);

----INSERT DATA INTO PARENT TABLE
INSERT ALL 
INTO parent VALUES('P001','Percy','Mokoena','0721113325')
INTO parent VALUES('P002','Lucy','Mokoka','0721713325')
INTO parent VALUES('P003','Peter','Lekona','0719173625')
INTO parent VALUES('P004','Pearl','Mokonoana','0731113895')
INTO parent VALUES('P005','Martin','Shongwe','0723114329')
SELECT * FROM dual;

----INSERT DATA INTO LEARNER TABLE
INSERT ALL
INTO learner VALUES('L001','P001','Khutjo','Mokoena','10-Oct-2015')
INTO learner VALUES('L002','P002','Khomotjo','Mokoka','12-Jun-2013')
INTO learner VALUES('L003','P003','Thabo','Lekona','25-Jul-2014')
INTO learner VALUES('L004','P004','Lucky','Mokonoana','11-Aug-2015')
INTO learner VALUES('L005','P005','Sello','Shongwe','02-Feb-2014')
SELECT * FROM dual;

----INSERT DATA INTO SPORT TABLE
INSERT ALL 
INTO sport VALUES('FB','Football')
INTO sport VALUES('NB','Netball')
INTO sport VALUES('Ath','Athletics')
INTO sport VALUES('CHE','Chess')
SELECT * FROM dual;

----INSERT DATA INTO REGISTRATION TABLE
INSERT ALL 
INTO registration VALUES('RE001','L001','NB',DEFAULT)
INTO registration VALUES('RE002','L001','Ath',DEFAULT)
INTO registration VALUES('RE003','L002','FB', DEFAULT)
INTO registration VALUES('RE004','L002','Ath', DEFAULT)
INTO registration VALUES('RE005','L002','CHE', DEFAULT)
INTO registration VALUES('RE006','L003','CHE', DEFAULT)
INTO registration VALUES('RE007','L003','FB', DEFAULT)
INTO registration VALUES('RE008','L004','FB', DEFAULT)
INTO registration VALUES('RE009','L005','FB',DEFAULT)
INTO registration VALUES('RE010','L005','CHE', DEFAULT)
SELECT * FROM dual;

----INSERT DATA INTO COACH TABLE
INSERT ALL 
INTO coach VALUES('CH01','Rodger','Chansa')
INTO coach VALUES('CH02','Sarah','Sebola')
INTO coach VALUES('CH03','Eddie','Maboya')
SELECT * FROM dual;

----INSERT DATA INTO TEAM TABLE
INSERT ALL 
INTO team VALUES('Fball','FB','CH01','Football Team')
INTO team VALUES('Nball','NB','CH02','Netball Team')
INTO team VALUES('Cclub','CHE','CH03','Chess Club')
INTO team VALUES('Athcs','Ath','CH03','Road Runner')
SELECT * FROM dual;

----INSERT DATA INTO LEARNERTEAM TABLE
INSERT ALL 
INTO learnerTeam VALUES('L001','Nball')
INTO learnerTeam VALUES('L001','Athcs')
INTO learnerTeam VALUES('L002','Fball')
INTO learnerTeam VALUES('L002','Athcs')
INTO learnerTeam VALUES('L002','Cclub')
INTO learnerTeam VALUES('L003','Cclub')
INTO learnerTeam VALUES('L003','Fball')
INTO learnerTeam VALUES('L004','Fball')
INTO learnerTeam VALUES('L005','Fball')
INTO learnerTeam VALUES('L005','Cclub')
SELECT * FROM dual;

COMMIT;


















  