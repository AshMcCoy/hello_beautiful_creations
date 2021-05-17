BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"first_name"	varchar(30) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"last_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$150000$XErJz2hlR1q0$KTsldW0B9VC1bcdObDRoMmL57PXIPDGWUvBPpHxXdrA=','2021-05-16 18:54:25.806011',1,'admin','','',1,1,'2021-04-26 12:31:37.939930','');
COMMIT;
