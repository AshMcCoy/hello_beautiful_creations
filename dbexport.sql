BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED
);
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
CREATE TABLE IF NOT EXISTS "hbc_app_orderitem" (
	"id"	integer NOT NULL,
	"ordered"	bool NOT NULL,
	"quantity"	integer NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"item_id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	FOREIGN KEY("item_id") REFERENCES "hbc_app_item"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "hbc_app_order_items" (
	"id"	integer NOT NULL,
	"order_id"	integer NOT NULL,
	"orderitem_id"	integer NOT NULL,
	FOREIGN KEY("orderitem_id") REFERENCES "hbc_app_orderitem"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "hbc_app_order"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "hbc_app_coupon" (
	"id"	integer NOT NULL,
	"code"	varchar(15) NOT NULL,
	"amount"	real NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "hbc_app_refund" (
	"id"	integer NOT NULL,
	"reason"	text NOT NULL,
	"accepted"	bool NOT NULL,
	"email"	varchar(254) NOT NULL,
	"order_id"	integer NOT NULL,
	FOREIGN KEY("order_id") REFERENCES "hbc_app_order"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "hbc_app_address" (
	"id"	integer NOT NULL,
	"street_address"	varchar(100) NOT NULL,
	"apartment_address"	varchar(100) NOT NULL,
	"city"	varchar(50) NOT NULL,
	"state"	varchar(2) NOT NULL,
	"country"	varchar(2) NOT NULL,
	"zip"	varchar(10) NOT NULL,
	"address_type"	varchar(1) NOT NULL,
	"default"	bool NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"user_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "hbc_app_payment" (
	"id"	integer NOT NULL,
	"paypal_charge_id"	varchar(50) NOT NULL,
	"amount"	real NOT NULL,
	"timestamp"	datetime NOT NULL,
	"user_id"	integer,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "hbc_app_order" (
	"id"	integer NOT NULL,
	"start_date"	datetime NOT NULL,
	"ordered_date"	datetime NOT NULL,
	"ordered"	bool NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"user_id"	integer NOT NULL,
	"billing_address_id"	integer,
	"coupon_id"	integer,
	"being_delivered"	bool NOT NULL,
	"received"	bool NOT NULL,
	"refund_granted"	bool NOT NULL,
	"refund_requested"	bool NOT NULL,
	"in_process"	bool NOT NULL,
	"ref_code"	varchar(20),
	"shipping_address_id"	integer,
	"payment_id"	integer,
	FOREIGN KEY("coupon_id") REFERENCES "hbc_app_coupon"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("billing_address_id") REFERENCES "hbc_app_address"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("payment_id") REFERENCES "hbc_app_payment"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("shipping_address_id") REFERENCES "hbc_app_address"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$150000$XErJz2hlR1q0$KTsldW0B9VC1bcdObDRoMmL57PXIPDGWUvBPpHxXdrA=','2021-05-16 18:54:25.806011',1,'admin','','',1,1,'2021-04-26 12:31:37.939930','');
INSERT INTO "hbc_app_coupon" VALUES (3,'TEST_COUPON',10.0);
INSERT INTO "hbc_app_address" VALUES (11,'1234 Happy Street','1235','Happy','TX','US','75358','S',1,'2021-05-15 21:59:09.410430','2021-05-15 21:59:09.410430',1);
INSERT INTO "hbc_app_address" VALUES (12,'1234 Happy Street','123','Happy','TX','US','75358','B',1,'2021-05-15 21:59:28.097053','2021-05-15 21:59:28.097053',1);
INSERT INTO "hbc_app_order" VALUES (5,'2021-05-07 15:03:49.265874','2021-05-07 15:03:45',1,'2021-05-07 15:03:49.265874','2021-05-12 21:12:22.893474',1,NULL,NULL,0,0,1,0,1,'123',NULL,NULL);
INSERT INTO "hbc_app_order" VALUES (6,'2021-05-07 15:35:05.039299','2021-05-07 15:35:05.039299',0,'2021-05-07 15:35:05.039299','2021-05-15 22:01:02.796070',1,12,3,0,0,0,0,1,'123',11,NULL);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_orderitem_item_id_0eac98fd" ON "hbc_app_orderitem" (
	"item_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_orderitem_user_id_32d28589" ON "hbc_app_orderitem" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "hbc_app_order_items_order_id_orderitem_id_c8753ab8_uniq" ON "hbc_app_order_items" (
	"order_id",
	"orderitem_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_order_items_order_id_669d0e15" ON "hbc_app_order_items" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_order_items_orderitem_id_769bedc1" ON "hbc_app_order_items" (
	"orderitem_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_refund_order_id_47f0b11d" ON "hbc_app_refund" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_address_user_id_3f1047d9" ON "hbc_app_address" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_payment_user_id_8f4b7d1e" ON "hbc_app_payment" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_order_user_id_2d86b2ec" ON "hbc_app_order" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_order_billing_address_id_f5f4faba" ON "hbc_app_order" (
	"billing_address_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_order_coupon_id_d5023a75" ON "hbc_app_order" (
	"coupon_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_order_shipping_address_id_2236d96c" ON "hbc_app_order" (
	"shipping_address_id"
);
CREATE INDEX IF NOT EXISTS "hbc_app_order_payment_id_891499fe" ON "hbc_app_order" (
	"payment_id"
);
COMMIT;
