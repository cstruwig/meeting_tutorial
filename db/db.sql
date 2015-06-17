
DROP TABLE IF EXISTS api_user;
CREATE TABLE api_user (
  id INT(10) NOT NULL AUTO_INCREMENT,
  user_name VARCHAR(20) NOT NULL,
  PASSWORD VARCHAR(100) NOT NULL,
  full_name VARCHAR(200) NOT NULL,
  address_line1 VARCHAR(200) NOT NULL,
  address_line2 VARCHAR(200) NULL,
  address_city VARCHAR(200) NOT NULL,
  address_province_code VARCHAR(5) NOT NULL,
  cell_no VARCHAR(50) NOT NULL,  
  card_no VARCHAR(50) NULL,  
  active BOOL DEFAULT 1,
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY user_name (user_name)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - users';

DROP TABLE IF EXISTS api_token;
CREATE TABLE api_token (
  id INT(10) NOT NULL AUTO_INCREMENT,
  user_id INT(10) NOT NULL,
  token CHAR(36) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY token (token)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - tokens';

DROP TABLE IF EXISTS api_token_failure;
CREATE TABLE api_token_failure (
  id INT(10) NOT NULL AUTO_INCREMENT,
  user_name VARCHAR(200) NULL,
  PASSWORD VARCHAR(200) NULL,
  token CHAR(36) NULL,
  host_name VARCHAR(200) NULL,
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY token (token)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - failed token requests';

DROP TABLE IF EXISTS api_host;
CREATE TABLE api_host (
  id INT(3) NOT NULL AUTO_INCREMENT,
  user_id INT(3) NOT NULL,
  host_name VARCHAR(100) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY user_id (user_id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Config - authorised hosts';

DROP TABLE IF EXISTS api_group;
CREATE TABLE api_group (
  id INT(10) NOT NULL AUTO_INCREMENT,
  group_name VARCHAR(100) NOT NULL,
  address_line1 VARCHAR(200) NOT NULL,
  address_line2 VARCHAR(200) NULL,
  address_city VARCHAR(200) NOT NULL,
  address_province_code VARCHAR(5) NOT NULL,
  facilitator_id INT(10) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY group_name (group_name)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - groups';

DROP TABLE IF EXISTS api_user_group;
CREATE TABLE api_user_group (
  id INT(10) NOT NULL AUTO_INCREMENT,
  user_id INT(10) NOT NULL,
  group_id INT(10) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - group members';

DROP TABLE IF EXISTS api_role;
CREATE TABLE api_role (
  id INT(10) NOT NULL AUTO_INCREMENT,
  description VARCHAR(30) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY description (description)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Config - roles';

DROP TABLE IF EXISTS api_user_role;
CREATE TABLE api_user_role (
  id INT(10) NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  role_id INT NOT NULL,  
  active BOOL DEFAULT 1,
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY user_id (user_id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - users and ther roles';

DROP TABLE IF EXISTS api_meeting;
CREATE TABLE api_meeting (
  id INT(10) NOT NULL AUTO_INCREMENT,
  user_id INT(10) NOT NULL, -- meeting creator
  group_id INT(10) NOT NULL,
  description VARCHAR(100) NOT NULL,
  location VARCHAR(200) NOT NULL,
  start_date DATETIME,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - meeting';

DROP TABLE IF EXISTS api_meeting_attendence;
CREATE TABLE api_meeting_attendence (
  id INT(10) NOT NULL AUTO_INCREMENT,
  meeting_id INT(10) NOT NULL,
  user_id INT(10) NOT NULL,
  attended BOOL DEFAULT 0,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY meeting_id (meeting_id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Transactional - meeting attendence';

DROP TABLE IF EXISTS api_list;
CREATE TABLE api_list (
  id INT(10) NOT NULL AUTO_INCREMENT,
  list_name VARCHAR(30) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY list_name (list_name)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Config - lists';

DROP TABLE IF EXISTS api_list_value;
CREATE TABLE api_list_value (
  id INT(10) NOT NULL AUTO_INCREMENT,
  list_id VARCHAR(30) NOT NULL,
  list_value VARCHAR(20) NOT NULL,
  list_option VARCHAR(20) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY list_id (list_id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Config - list values';

DROP TABLE IF EXISTS api_contact;
CREATE TABLE api_contact (
  id INT(3) NOT NULL AUTO_INCREMENT,
  contact_name VARCHAR(300) NOT NULL,
  contact_no VARCHAR(30) NOT NULL,
  user_id INT(3) NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY user_id (user_id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Config - app contacts';

DROP TABLE IF EXISTS api_publication;
CREATE TABLE api_publication (
  id INT(3) NOT NULL AUTO_INCREMENT,
  group_id INT NOT NULL,
  description VARCHAR(300) NOT NULL,
  source VARCHAR(300) NOT NULL,
  active BOOL DEFAULT 1,  
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,  
  PRIMARY KEY (id),
  KEY group_id (group_id)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Config - grpup publications';

DROP PROCEDURE IF EXISTS api_get_contact;

DELIMITER $api_get_contact
CREATE PROCEDURE api_get_contact (_page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);
  
  SELECT contact_name, contact_no
  FROM api_contact
  WHERE active = 1
  ORDER BY 1
  LIMIT _page, _size;

END $api_get_contact

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_publication;

DELIMITER $api_get_publication
CREATE PROCEDURE api_get_publication (_page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);
  
  SELECT P.description, P.source, G.group_name
  FROM api_publication P
  JOIN api_group G
  ON G.id = P.group_id
  WHERE P.active = 1
  ORDER BY P.description
  LIMIT _page, _size;

END $api_get_publication

DELIMITER ;

DROP PROCEDURE IF EXISTS api_find_publication_by_group_id;

DELIMITER $api_find_publication_by_group_id
CREATE PROCEDURE api_find_publication_by_group_id (_group_id INT, _page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);
  
  SELECT P.description, P.source, G.group_name
  FROM api_publication P
  JOIN api_group G
  ON G.id = P.group_id AND P.group_id = _group_id
  WHERE P.active = 1
  ORDER BY P.description
  LIMIT _page, _size;
  
END $api_find_publication_by_group_id

DELIMITER ;

DROP PROCEDURE IF EXISTS api_add_token;

DELIMITER $api_add_token
CREATE PROCEDURE api_add_token (_userName VARCHAR(50), _password VARCHAR(50), _hostName VARCHAR(200))
procedure_block:BEGIN
  DECLARE token_valid_seconds INT(3) DEFAULT 600;
  DECLARE user_id INT;
  DECLARE token CHAR(36);
  DECLARE expires INT;
  DECLARE host_name VARCHAR(50);

  /* DBA - SEE THIS ----> http://itecsoftware.com/WITH-nolock-TABLE-hint-equivalent-FOR-mysql */
  
  /* get the user id AND any "recent" tokens (last 600 seconds) */
  SELECT 
    U.id, 
    T.token,
    H.host_name,
    token_valid_seconds - TIME_TO_SEC(TIMEDIFF(NOW(), T.date_added))
  INTO
    user_id,
    token,
    host_name,
    expires
  FROM
    api_user U
  LEFT JOIN api_token T          /* LEFT JOIN as no tokens exist potentially */
    ON (U.id = T.user_id)
  LEFT JOIN api_host H
    ON (LCASE(H.host_name) = LCASE(_hostName))
  WHERE (U.user_name = _userName AND U.password = PASSWORD(_password))
  ORDER BY T.date_added DESC
  LIMIT 1;
  
  /* invalid username, password or host */
  IF user_id IS NULL OR host_name IS NULL THEN
    INSERT INTO api_token_failure (user_name, PASSWORD, host_name) VALUES (_userName, _password, _hostName);
    SELECT
      NULL 'token',
      -1 'expires',
      'unauthorised' AS 'status';
    LEAVE procedure_block;
  END IF;

  /* check for existing token validity */
  IF expires > 0 THEN
   /* recycle it! */
    SELECT
      token 'token',
      expires 'expires',
      'active' AS 'status';
    LEAVE procedure_block;
  END IF;
    
  /* at this point we verified the credentials and the host so a new token must be generated */
  SET token := UUID();
  INSERT INTO api_tokens (user_id, token, date_added)
  VALUES (user_id, token, NOW());
    
  /* return new token */
  SELECT
    token 'token', 
    token_valid_seconds 'expires', 
    'new' AS 'status';
END $api_add_token

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_token;

DELIMITER $api_get_token

CREATE PROCEDURE api_get_token (_token VARCHAR(36), _hostName VARCHAR(200))  
procedure_block:BEGIN

  /* SET SESSION group_concat_max_len = 8192; */

  DECLARE token_valid_seconds INT(3) DEFAULT 600;
  DECLARE user_name VARCHAR(100);
  DECLARE date_added DATETIME;
  DECLARE configured_hosts VARCHAR(2000); /* 10 host names of 100 chars each? */
  
  /* get the company id AND any "recent" tokens (last 600 seconds) */
  SELECT 
    U.user_name,
    T.date_added,
    GROUP_CONCAT(H.host_name)
  INTO
    user_name,
    date_added,
    configured_hosts
  FROM
    api_token T
  JOIN api_user U
    ON (T.user_id = U.id)
  JOIN api_host H
    ON (H.user_id = U.id)
  WHERE (T.token = _token);
    
  /* no record means invalid token */
  IF user_name IS NULL THEN 
    INSERT INTO api_token_failure (token, host_name) VALUES (_token, _hostName);
    SELECT
      NULL 'user',
      NULL 'date_added',
      'invalid' AS 'status';
    LEAVE procedure_block;
  END IF;
    
  /* return new token */
  SELECT
    user_name 'user', 
    date_added 'date_added', 
    IF(TIME_TO_SEC(TIMEDIFF(NOW(), date_added)) > token_valid_seconds, 'expired', 'active') AS 'status',
    configured_hosts 'hosts';
END $api_get_token

DELIMITER ;

DROP PROCEDURE IF EXISTS api_find_group;

DELIMITER $api_find_group

CREATE PROCEDURE api_find_group (_group_name VARCHAR(200), _page INT, _size INT)  
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

  SELECT *
  FROM api_group
  WHERE LCASE(group_name) LIKE CONCAT('%', LCASE(_group_name), '%')
  AND active = 1  
  ORDER BY 1
  LIMIT _page, _size; 
  
END $api_find_group

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_group;

DELIMITER $api_get_group

CREATE PROCEDURE api_get_group (_page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

  SELECT *
  FROM api_group
  WHERE active = 1
  ORDER BY 1
  LIMIT _page, _size;
  
END $api_get_group

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_group_by_id;

DELIMITER $api_get_group_by_id

CREATE PROCEDURE api_get_group_by_id (_id VARCHAR(50))  
procedure_block:BEGIN

  SELECT *
  FROM api_group
  WHERE id = _id
  AND active = 1
  ORDER BY 1
  LIMIT 1;
  
END $api_get_group_by_id

DELIMITER ;

DROP PROCEDURE IF EXISTS api_add_group;

DELIMITER $api_add_group

CREATE PROCEDURE api_add_group (_group_name VARCHAR(100), _address_line1 VARCHAR(200), _address_line2 VARCHAR(200), _address_city VARCHAR(200), _address_province_code VARCHAR(5), _facilitator_id INT)

procedure_block:BEGIN

  INSERT INTO api_group (group_name, address_line1, address_line2, address_city, address_province_code, facilitator_id)
  VALUES (_group_name, _address_line1, _address_line2, _address_city, _address_province_code, _facilitator_id);
  
  CALL api_get_group_by_id(LAST_INSERT_ID());
 
END $api_add_group

DELIMITER ;

DROP PROCEDURE IF EXISTS api_update_group;

DELIMITER $api_update_group

CREATE PROCEDURE api_update_group (_id INT, _group_name VARCHAR(100), _address_line1 VARCHAR(200), _address_line2 VARCHAR(200), _address_city VARCHAR(200), _address_province_code VARCHAR(5), _facilitator_id INT)

procedure_block:BEGIN

  UPDATE api_group
  SET group_name = IFNULL(_group_name, group_name),
  address_line1 = IFNULL(_address_line1, address_line1),
  address_line2 = IFNULL(_address_line2, address_line2),
  address_city = IFNULL(_address_city, address_city),
  address_province_code = IFNULL(_address_province_code, address_province_code),
  facilitator_id = IFNULL(_facilitator_id, facilitator_id)
  WHERE id = _id;
  
  CALL api_get_group_by_id(id);
 
END $api_update_group

DELIMITER ;

DROP PROCEDURE IF EXISTS api_delete_group;

DELIMITER $api_delete_group

CREATE PROCEDURE api_delete_group (_id INT)

procedure_block:BEGIN

  UPDATE api_group
  SET active = 0
  WHERE id = _id;
 
END $api_delete_group

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_list_by_name;

DELIMITER $api_get_list_by_name

CREATE PROCEDURE api_get_list_by_name (_group_name VARCHAR(50), _page INT, _size INT)  
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

  SELECT V.list_value VALUE, V.list_option TEXT
  FROM api_list L
  JOIN api_list_value V
  ON (V.list_id = L.id AND L.active = 1 AND V.active = 1)
  WHERE LCASE(L.list_name) = LCASE(_group_name)
  ORDER BY 2
  LIMIT _page, _size;
  
END $api_get_list_by_name

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_user;

DELIMITER $api_get_user

CREATE PROCEDURE api_get_user(_page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

-- //FIX! exclude password!
  SELECT *
  FROM api_user
  WHERE active = 1
  ORDER BY 2
  LIMIT _page, _size;
  
END $api_get_user

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_user_by_id;

DELIMITER $api_get_user_by_id

CREATE PROCEDURE api_get_user_by_id (_id INT)  
procedure_block:BEGIN

  SELECT
    U.id,
    U.full_name,
    U.address_line1,
    U.address_line2,
    U.address_city,
    U.address_province_code, 
    U.cell_no,
    U.card_no
  FROM api_user U
/*   JOIN api_user_role UR
    ON U.id = UR.user_id AND U.active = 1
  JOIN api_role R
    ON R.id = UR.role_id  AND R.active = 1 */
  WHERE U.id = _id;
  
END $api_get_user_by_id

DELIMITER ;

DROP PROCEDURE IF EXISTS api_add_user;

DELIMITER $api_add_user

CREATE PROCEDURE api_add_user (_user_name VARCHAR(20), _password VARCHAR(100), _full_name VARCHAR(200), _address_line1 VARCHAR(200), _address_line2 VARCHAR(200), _address_city VARCHAR(200), _address_province_code VARCHAR(5), _cell_no VARCHAR(50), _card_no VARCHAR(50))

procedure_block:BEGIN

  INSERT INTO api_user (user_name, PASSWORD, full_name, address_line1, address_line2, address_city, address_province_code, cell_no, card_no)
  VALUES (_user_name, PASSWORD(_password), _full_name, _address_line1, _address_line2, _address_city, _address_province_code, _cell_no, _card_no);
  
  CALL api_get_user_by_id(LAST_INSERT_ID());
 
END $api_add_user

DELIMITER ;

DROP PROCEDURE IF EXISTS api_update_user;

DELIMITER $api_update_user

CREATE PROCEDURE api_update_user (_id INT(10), _password VARCHAR(100), _full_name VARCHAR(200), _address_line1 VARCHAR(200), _address_line2 VARCHAR(200), _address_city VARCHAR(200), _address_province_code VARCHAR(5), _cell_no VARCHAR(50), card_no VARCHAR(50))

procedure_block:BEGIN

  UPDATE api_user
  SET PASSWORD := IFNULL(PASSWORD(_password), PASSWORD), 
  full_name := IFNULL(_full_name, full_name), 
  address_line1 := IFNULL(_address_line1, address_line1), 
  address_line2 := IFNULL(_address_line2, address_line2), 
  address_city := IFNULL(_address_city, address_city),
  address_province_code := IFNULL(_address_province_code, address_province_code),
  cell_no := IFNULL(_cell_no, cell_no),
  card_no := IFNULL(_card_no, card_no)
  WHERE id = _id;
  
  CALL api_get_user_by_id(_id);
 
END $api_update_user

DELIMITER ;

DROP PROCEDURE IF EXISTS api_delete_user;

DELIMITER $api_delete_user

CREATE PROCEDURE api_delete_user (_id INT)

procedure_block:BEGIN

  UPDATE api_user
  SET active = 0
  WHERE id = _id;
 
END $api_delete_user

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_user_by_role;

DELIMITER $api_get_user_by_role

CREATE PROCEDURE api_get_user_by_role (_role VARCHAR(50), _page INT, _size INT)  
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

  SELECT
    U.id,
    U.full_name,
    U.address_line1,
    U.address_line2,
    U.address_city,
    U.address_province_code, 
    U.cell_no,
    U.card_no
  FROM api_user U
  JOIN api_user_role UR
    ON U.id = UR.user_id AND U.active = 1
  JOIN api_role R
    ON R.id = UR.role_id  AND R.active = 1
  WHERE LCASE(R.description) = LCASE(_role)
  ORDER BY 2
  LIMIT _page, _size;
  
END $api_get_user_by_role

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_meeting;

DELIMITER $api_get_meeting

CREATE PROCEDURE api_get_meeting(_page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

  SELECT *
  FROM api_meeting
  WHERE active = 1
  ORDER BY 2
  LIMIT _page, _size;
  
END $api_get_meeting

DELIMITER ;

DROP PROCEDURE IF EXISTS api_get_meeting_by_id;

DELIMITER $api_get_meeting_by_id

CREATE PROCEDURE api_get_meeting_by_id(_id INT)
procedure_block:BEGIN

  SELECT 
    M.id,
    M.description,
    M.
    GROUPCONCAT()
  FROM api_meeting M
  JOIN api_meeting_attendence A
    ON A.meeting_id = M.id
  WHERE M.id = _id
  ORDER BY 2;
  
END $api_get_meeting_by_id

DELIMITER ;

DROP PROCEDURE IF EXISTS api_find_meeting_by_user_id;

DELIMITER $api_find_meeting_by_user_id

CREATE PROCEDURE api_find_meeting_by_user_id(_user_id INT, _page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

  SELECT *
  FROM api_meeting
  WHERE user_id = _user_id
  AND active = 1
  ORDER BY 2
  LIMIT _page, _size;
  
END $api_find_meeting_by_user_id

DELIMITER ;

DROP PROCEDURE IF EXISTS api_find_meeting_by_description;

DELIMITER $api_find_meeting_by_description

CREATE PROCEDURE api_find_meeting_by_description(_description VARCHAR(100), _page INT, _size INT)
procedure_block:BEGIN

  SET _page := IF(_page = -1, 0, _page);
  SET _size := IF(_size = -1, 1000, _size);

  SELECT *
  FROM api_meeting
  WHERE LCASE(description) LIKE CONCAT('%', LCASE(_description), '%')
  AND active = 1
  ORDER BY 2
  LIMIT _page, _size;
  
END $api_find_meeting_by_description

DELIMITER ;

DROP PROCEDURE IF EXISTS api_add_meeting;

DELIMITER $api_add_meeting

CREATE PROCEDURE api_add_meeting(_user_id INT, _group_id INT, _description VARCHAR(100), _location VARCHAR(200), _start_date DATETIME)
procedure_block:BEGIN
  
  INSERT INTO api_meeting (user_id, group_id, description, location, start_date)
  VALUES (_user_id, _group_id, _description, _location, _start_date);
  
  CALL api_get_meeting_by_id(LAST_INSERT_ID());
  
END $api_add_meeting

DELIMITER ;

DROP PROCEDURE IF EXISTS api_update_meeting_attendance;

DELIMITER $api_update_meeting_attendance

CREATE PROCEDURE api_update_meeting_attendance(_meeting_id INT, _user_id INT, _attended BOOL)
procedure_block:BEGIN

  IF EXISTS(SELECT * FROM api_meeting_attendence WHERE meeting_id = _meeting_id AND user_id = _user_id) THEN
    BEGIN
      UPDATE api_meeting_attendence
      SET attended = _attended
      WHERE meeting_id = _meeting_id AND user_id = _user_id;
    END;
  ELSE
    BEGIN
    INSERT INTO api_meeting_attendence (meeting_id, user_id, attended)
    VALUES (_meeting_id, _user_id, _attended);
/*     ON DUPLICATE KEY UPDATE attended = _attended; */
    END;
  END IF;
  
  CALL api_get_meeting_by_id(_meeting_id);
  
END $api_update_meeting_attendance

DELIMITER ;

INSERT INTO api_token (user_id, token, date_added) VALUES (1, UUID(), '2222-01-01');

INSERT INTO api_user (user_name, PASSWORD, full_name, address_line1, address_line2, address_city, address_province_code, cell_no) VALUES ('admin', PASSWORD('nimda'), 'Andre', 'address line ONE', 'address line TWO', 'address CITY', 1, 'cell NO');
INSERT INTO api_user (user_name, PASSWORD, full_name, address_line1, address_line2, address_city, address_province_code, cell_no) VALUES ('hardus', PASSWORD('hardus'), 'Hardus van der Berg', '486 de jonge str', 'elarduspark', 'PTA', 3, '0716718133');

INSERT INTO api_host (user_id, host_name) VALUES (1, '127.0.0.1:3001');
INSERT INTO api_host (user_id, host_name) VALUES (1, 'localhost:3001');
INSERT INTO api_host (user_id, host_name) VALUES (1, 'nutshell.does-it.net:3001');
INSERT INTO api_host (user_id, host_name) VALUES (1, 'localhost:8100');

INSERT INTO api_role (description) VALUES ('Administrator');
INSERT INTO api_role (description) VALUES ('Facilitator');
INSERT INTO api_role (description) VALUES ('Liaison Officer');
INSERT INTO api_role (description) VALUES ('Site Manager');
INSERT INTO api_role (description) VALUES ('Member');

INSERT INTO api_user_role (user_id, role_id) VALUES (1, 1);
INSERT INTO api_user_role (user_id, role_id) VALUES (1, 2);
INSERT INTO api_user_role (user_id, role_id) VALUES (1, 3);
INSERT INTO api_user_role (user_id, role_id) VALUES (1, 4);
INSERT INTO api_user_role (user_id, role_id) VALUES (1, 5);

INSERT INTO api_user_role (user_id, role_id) VALUES (2, 1);
INSERT INTO api_user_role (user_id, role_id) VALUES (2, 3);

INSERT INTO api_list (list_name) VALUES ('province');

INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'EC', 'Eastern Cape');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'FS', 'Freestate');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'GP', 'Gauteng');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'ZN', 'KwaZulu Natal');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'LI', 'Limpopo');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'MP', 'Mpumalanga');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'NW', 'North West');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'NC', 'Northern Cape');
INSERT INTO api_list_value (list_id, list_value, list_option) VALUES (1, 'WC', 'Western Cape');

INSERT INTO api_group (group_name, address_line1, address_line2, address_city, address_province_code, facilitator_id)  VALUES ('ONE GROUP TO rule them ALL', 'address line ONE', 'address line TWO', 'address CITY', 'LI', 1);

INSERT INTO api_user_group (user_id, group_id) VALUES (1, 1);

INSERT INTO api_contact (contact_name, contact_no) VALUES ('example contact 1', '012 345 6789');
INSERT INTO api_contact (contact_name, contact_no) VALUES ('example contact 2', '012 345 2222');
INSERT INTO api_contact (contact_name, contact_no) VALUES ('example contact 3', '012 345 3333');

INSERT INTO api_meeting (user_id, group_id, description, location, start_date) VALUES (1, 1, 'Test Meeting', 'Wimpy', '2015-07-01');

INSERT INTO api_publication (group_id, description, source) VALUES (1, 'example publication 1', 'http://fzs.sve-mo.ba/sites/DEFAULT/files/dokumenti-vijesti/sample.pdf');
INSERT INTO api_publication (group_id, description, source) VALUES (1, 'example publication 2', 'http://www.snee.com/xml/xslt/sample.doc');
INSERT INTO api_publication (group_id, description, source) VALUES (1, 'example publication 3', 'https://www.burningwheel.com/store/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/t/a/tableofcontents.jpg');