BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
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
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "account_emailconfirmation" (
	"id"	integer NOT NULL,
	"created"	datetime NOT NULL,
	"sent"	datetime,
	"key"	varchar(64) NOT NULL UNIQUE,
	"email_address_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("email_address_id") REFERENCES "account_emailaddress"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "account_emailaddress" (
	"id"	integer NOT NULL,
	"verified"	bool NOT NULL,
	"primary"	bool NOT NULL,
	"user_id"	integer NOT NULL,
	"email"	varchar(254) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_site" (
	"id"	integer NOT NULL,
	"name"	varchar(50) NOT NULL,
	"domain"	varchar(100) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialapp_sites" (
	"id"	integer NOT NULL,
	"socialapp_id"	integer NOT NULL,
	"site_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("socialapp_id") REFERENCES "socialaccount_socialapp"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("site_id") REFERENCES "django_site"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialtoken" (
	"id"	integer NOT NULL,
	"token"	text NOT NULL,
	"token_secret"	text NOT NULL,
	"expires_at"	datetime,
	"account_id"	integer NOT NULL,
	"app_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("app_id") REFERENCES "socialaccount_socialapp"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("account_id") REFERENCES "socialaccount_socialaccount"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialapp" (
	"id"	integer NOT NULL,
	"provider"	varchar(30) NOT NULL,
	"name"	varchar(40) NOT NULL,
	"client_id"	varchar(191) NOT NULL,
	"key"	varchar(191) NOT NULL,
	"secret"	varchar(191) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "socialaccount_socialaccount" (
	"id"	integer NOT NULL,
	"provider"	varchar(30) NOT NULL,
	"uid"	varchar(191) NOT NULL,
	"last_login"	datetime NOT NULL,
	"date_joined"	datetime NOT NULL,
	"user_id"	integer NOT NULL,
	"extra_data"	text NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "hbc_app_orderitem" (
	"id"	integer NOT NULL,
	"ordered"	bool NOT NULL,
	"quantity"	integer NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"item_id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("item_id") REFERENCES "hbc_app_item"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "hbc_app_order_items" (
	"id"	integer NOT NULL,
	"order_id"	integer NOT NULL,
	"orderitem_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("orderitem_id") REFERENCES "hbc_app_orderitem"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("order_id") REFERENCES "hbc_app_order"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "hbc_app_item" (
	"id"	integer NOT NULL,
	"item_name"	varchar(100) NOT NULL,
	"price"	real NOT NULL,
	"discount_price"	real,
	"category"	varchar(3) NOT NULL,
	"description"	text NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"image"	varchar(100),
	"shirt_color"	varchar(50),
	"available"	bool NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
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
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "hbc_app_order"("id") DEFERRABLE INITIALLY DEFERRED
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
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "hbc_app_payment" (
	"id"	integer NOT NULL,
	"paypal_charge_id"	varchar(50) NOT NULL,
	"amount"	real NOT NULL,
	"timestamp"	datetime NOT NULL,
	"user_id"	integer,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
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
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("shipping_address_id") REFERENCES "hbc_app_address"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("coupon_id") REFERENCES "hbc_app_coupon"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("payment_id") REFERENCES "hbc_app_payment"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("billing_address_id") REFERENCES "hbc_app_address"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
INSERT INTO "django_migrations" VALUES (1,'contenttypes','0001_initial','2021-04-26 12:18:28.775274');
INSERT INTO "django_migrations" VALUES (2,'auth','0001_initial','2021-04-26 12:18:28.909914');
INSERT INTO "django_migrations" VALUES (3,'admin','0001_initial','2021-04-26 12:18:29.046553');
INSERT INTO "django_migrations" VALUES (4,'admin','0002_logentry_remove_auto_add','2021-04-26 12:18:29.163238');
INSERT INTO "django_migrations" VALUES (5,'admin','0003_logentry_add_action_flag_choices','2021-04-26 12:18:29.281919');
INSERT INTO "django_migrations" VALUES (6,'contenttypes','0002_remove_content_type_name','2021-04-26 12:18:29.386640');
INSERT INTO "django_migrations" VALUES (7,'auth','0002_alter_permission_name_max_length','2021-04-26 12:18:29.515295');
INSERT INTO "django_migrations" VALUES (8,'auth','0003_alter_user_email_max_length','2021-04-26 12:18:29.627994');
INSERT INTO "django_migrations" VALUES (9,'auth','0004_alter_user_username_opts','2021-04-26 12:18:29.717755');
INSERT INTO "django_migrations" VALUES (10,'auth','0005_alter_user_last_login_null','2021-04-26 12:18:29.801531');
INSERT INTO "django_migrations" VALUES (11,'auth','0006_require_contenttypes_0002','2021-04-26 12:18:29.877329');
INSERT INTO "django_migrations" VALUES (12,'auth','0007_alter_validators_add_error_messages','2021-04-26 12:18:30.012255');
INSERT INTO "django_migrations" VALUES (13,'auth','0008_alter_user_username_max_length','2021-04-26 12:18:30.145897');
INSERT INTO "django_migrations" VALUES (14,'auth','0009_alter_user_last_name_max_length','2021-04-26 12:18:30.278545');
INSERT INTO "django_migrations" VALUES (15,'auth','0010_alter_group_name_max_length','2021-04-26 12:18:30.351350');
INSERT INTO "django_migrations" VALUES (16,'auth','0011_update_proxy_permissions','2021-04-26 12:18:30.452000');
INSERT INTO "django_migrations" VALUES (17,'sessions','0001_initial','2021-04-26 12:18:30.538899');
INSERT INTO "django_migrations" VALUES (18,'account','0001_initial','2021-04-26 13:28:41.274366');
INSERT INTO "django_migrations" VALUES (19,'account','0002_email_max_length','2021-04-26 13:28:41.421154');
INSERT INTO "django_migrations" VALUES (20,'sites','0001_initial','2021-04-26 13:28:41.528348');
INSERT INTO "django_migrations" VALUES (21,'sites','0002_alter_domain_unique','2021-04-26 13:28:41.630427');
INSERT INTO "django_migrations" VALUES (22,'socialaccount','0001_initial','2021-04-26 13:28:41.816822');
INSERT INTO "django_migrations" VALUES (23,'socialaccount','0002_token_max_lengths','2021-04-26 13:28:42.005406');
INSERT INTO "django_migrations" VALUES (24,'socialaccount','0003_extra_data_default_dict','2021-04-26 13:28:42.156139');
INSERT INTO "django_migrations" VALUES (25,'hbc_app','0001_initial','2021-04-26 15:03:18.256565');
INSERT INTO "django_migrations" VALUES (26,'hbc_app','0002_checkoutaddress','2021-04-27 01:00:32.767652');
INSERT INTO "django_migrations" VALUES (27,'hbc_app','0003_auto_20210427_0713','2021-04-27 12:13:46.191266');
INSERT INTO "django_migrations" VALUES (28,'hbc_app','0004_auto_20210503_1111','2021-05-03 16:11:57.465488');
INSERT INTO "django_migrations" VALUES (29,'hbc_app','0005_item_shirt_color','2021-05-03 19:54:22.671690');
INSERT INTO "django_migrations" VALUES (30,'hbc_app','0006_auto_20210504_0814','2021-05-04 13:14:21.268619');
INSERT INTO "django_migrations" VALUES (31,'hbc_app','0007_auto_20210507_0920','2021-05-07 14:20:37.189301');
INSERT INTO "django_migrations" VALUES (32,'hbc_app','0008_auto_20210507_1034','2021-05-07 15:34:19.845206');
INSERT INTO "django_migrations" VALUES (33,'hbc_app','0009_auto_20210509_1512','2021-05-09 20:12:57.617364');
INSERT INTO "django_migrations" VALUES (34,'hbc_app','0010_auto_20210510_0845','2021-05-10 13:45:22.706687');
INSERT INTO "django_migrations" VALUES (35,'hbc_app','0011_order_billing_address','2021-05-10 13:49:39.447632');
INSERT INTO "django_migrations" VALUES (36,'hbc_app','0012_auto_20210510_0901','2021-05-10 14:01:29.277087');
INSERT INTO "django_migrations" VALUES (37,'hbc_app','0013_item_available','2021-05-12 15:28:14.276695');
INSERT INTO "django_migrations" VALUES (38,'hbc_app','0014_coupon','2021-05-12 15:56:38.466974');
INSERT INTO "django_migrations" VALUES (39,'hbc_app','0015_order_coupon','2021-05-12 17:57:57.805364');
INSERT INTO "django_migrations" VALUES (40,'hbc_app','0016_coupon_amount','2021-05-12 18:28:19.646632');
INSERT INTO "django_migrations" VALUES (41,'hbc_app','0017_auto_20210512_1410','2021-05-12 19:10:24.962959');
INSERT INTO "django_migrations" VALUES (42,'hbc_app','0018_order_in_process','2021-05-12 19:14:11.258707');
INSERT INTO "django_migrations" VALUES (43,'hbc_app','0019_order_ref_code','2021-05-12 19:30:05.940412');
INSERT INTO "django_migrations" VALUES (44,'hbc_app','0020_refund','2021-05-12 20:01:33.279417');
INSERT INTO "django_migrations" VALUES (45,'hbc_app','0021_auto_20210513_0954','2021-05-13 14:54:55.600207');
INSERT INTO "django_migrations" VALUES (46,'hbc_app','0022_auto_20210514_1219','2021-05-14 17:20:00.640168');
INSERT INTO "django_migrations" VALUES (47,'hbc_app','0023_auto_20210514_1237','2021-05-14 17:37:53.316800');
INSERT INTO "django_admin_log" VALUES (1,'2021-04-26 16:02:58.585980','1','purple_mama_tee','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (2,'2021-04-26 18:47:19.991502','1','Rainbow Mama Tee','[{"changed": {"fields": ["item_name", "description"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (3,'2021-04-26 18:47:45.680940','1','Rainbow Mama Tee','[]',15,1,2);
INSERT INTO "django_admin_log" VALUES (4,'2021-04-27 13:08:09.784528','2','Rainbow Mini Tee','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (5,'2021-04-29 14:41:59.724408','3','Mama Floral','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (6,'2021-04-29 14:43:17.004814','4','Mama Brushstrokes','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (7,'2021-04-29 14:43:46.988948','5','Lucky Mama','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (8,'2021-04-29 14:46:37.458238','6','Mama Vibes','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (9,'2021-04-29 14:47:15.459424','7','Mama Tried','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (10,'2021-04-29 14:47:47.519359','8','Love','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (11,'2021-04-29 14:48:14.787034','9','Ew Cupid','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (12,'2021-04-29 14:48:47.130322','10','But Did You Dye?','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (13,'2021-04-29 14:49:24.565395','11','Tacos Are My Valentine','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (14,'2021-04-29 14:50:02.459470','12','So Eggstra','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (15,'2021-04-29 14:50:58.320933','13','(Nurse) I''ll Be There For You','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (16,'2021-04-29 14:51:51.165694','14','Shenanigans Expert','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (17,'2021-05-03 16:15:52.545649','14','Shenanigans Expert','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (18,'2021-05-03 16:16:11.731825','13','(Nurse) I''ll Be There For You','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (19,'2021-05-03 16:16:41.107534','12','So Eggstra','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (20,'2021-05-03 16:16:52.518772','11','Tacos Are My Valentine','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (21,'2021-05-03 16:17:09.184896','10','But Did You Dye?','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (22,'2021-05-03 16:17:19.000760','9','Ew Cupid','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (23,'2021-05-03 16:17:31.202550','8','Love','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (24,'2021-05-03 16:17:41.310254','7','Mama Tried','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (25,'2021-05-03 16:17:54.063915','6','Mama Vibes','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (26,'2021-05-03 16:18:04.502573','5','Lucky Mama','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (27,'2021-05-03 16:18:22.352533','4','Mama Brushstrokes','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (28,'2021-05-03 16:18:34.457420','3','Mama Floral','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (29,'2021-05-03 16:19:01.156326','2','Rainbow Mini Tee','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (30,'2021-05-03 16:19:13.378689','1','Rainbow Mama Tee','[{"changed": {"fields": ["image"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (31,'2021-05-04 12:53:07.701540','15','But Did You Dye? (Bunny)','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (32,'2021-05-04 12:54:18.038654','16','Go Jesus...it''s the Third Day','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (33,'2021-05-04 12:55:29.999548','17','Leopard Bunny Ears','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (34,'2021-05-04 12:56:36.903989','18','Leopard Cross','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (35,'2021-05-04 12:57:37.638103','19','Hip Hop','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (36,'2021-05-04 12:59:52.284002','20','Kissing 100 Days Goodbye','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (37,'2021-05-04 13:00:07.645314','20','Kissing 100 Days Goodbye','[{"changed": {"fields": ["shirt_color"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (38,'2021-05-04 13:01:47.353864','21','Raising My Tribe on Jesus Vibes','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (39,'2021-05-04 13:02:30.356150','22','He Is Risen','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (40,'2021-05-04 13:11:30.459094','23','Black with Pearls','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (41,'2021-05-04 13:14:47.363287','23','Black with Pearls','[{"changed": {"fields": ["shirt_color"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (42,'2021-05-04 13:19:12.842729','24','Rust Head Wrap Fluff','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (43,'2021-05-04 13:21:33.533648','25','Candy Cane Cloth Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (44,'2021-05-04 13:22:48.428902','26','Christmas Plaid Center','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (45,'2021-05-04 13:25:11.215105','27','Christmas Ribbon Bow Piggies','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (46,'2021-05-04 13:26:11.690185','28','Classic Red Plaid Cloth Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (47,'2021-05-04 13:27:21.646789','29','Classic Plaid Poinsettia','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (48,'2021-05-04 13:27:56.087348','30','Farm Market Christmas','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (49,'2021-05-04 13:29:12.758788','31','Layered Floral Pumpkin Leather Bow Set','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (50,'2021-05-04 13:30:29.604458','32','Ghostbuster Piggies','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (51,'2021-05-04 13:33:36.040684','33','Grinch Christmas','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (52,'2021-05-04 13:34:10.339287','34','Halloween Piggy Set','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (53,'2021-05-04 13:35:11.367608','35','Layered Black Glitter Halloween Piggy Set','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (54,'2021-05-04 13:36:07.045586','36','Layered Striped Halloween Ribbon Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (55,'2021-05-04 13:36:59.256864','37','Hello Love Ribbon Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (56,'2021-05-04 13:37:30.888449','38','Hocus Pocus Cloth Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (57,'2021-05-04 13:38:17.600531','39','Icecream Cloth Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (58,'2021-05-04 13:39:51.600269','40','Harry Potter Cloth Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (59,'2021-05-04 13:41:16.336458','41','Sunflower Striped Cloth Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (60,'2021-05-04 13:42:38.607770','42','Fiesta Cloth Piggy Set','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (61,'2021-05-04 13:46:15.211234','43','American Stars & Stripes Bows','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (62,'2021-05-04 13:47:14.547801','44','Multi-print Cloth Bows','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (63,'2021-05-04 13:48:24.917637','45','Leopard Sunflower','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (64,'2021-05-04 13:49:03.355701','46','Puzzle Pieces','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (65,'2021-05-04 13:49:40.504125','47','Neon Yellow Cloth Bows','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (66,'2021-05-04 13:50:22.329972','48','Layered Kisses Ribbon Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (67,'2021-05-04 13:50:52.101004','49','Leopard Christmas Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (68,'2021-05-04 13:52:05.569717','50','Leopard Lions Turban Wrap','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (69,'2021-05-04 13:52:50.386645','51','Leopard Lions Ribbon Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (70,'2021-05-04 13:53:38.349591','52','Valentine''s Love Layered Bow','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (71,'2021-05-04 13:54:19.847673','53','Happy New Year','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (72,'2021-05-04 13:54:48.339056','54','Ornament Christmas','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (73,'2021-05-04 13:55:26.042695','55','Kisses','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (74,'2021-05-04 13:56:36.309925','56','Purple Glitter Pumpkin','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (75,'2021-05-04 13:57:20.760534','57','Queen','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (76,'2021-05-04 13:58:27.856427','58','Flannel Christmas Piggy Set','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (77,'2021-05-04 13:59:00.625657','59','Red Glitter','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (78,'2021-05-04 13:59:38.044556','60','Red Sequin','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (79,'2021-05-04 14:00:32.752020','61','Salmon Pink School','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (80,'2021-05-04 14:01:05.316533','62','Santa Buckle Piggy Set','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (81,'2021-05-04 14:01:45.876612','63','Santa Leopard','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (82,'2021-05-04 14:02:19.661030','64','School','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (83,'2021-05-04 14:03:12.106296','65','School Spirit','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (84,'2021-05-04 14:03:51.916666','66','Red & Black School Spirit','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (85,'2021-05-04 14:04:42.017034','67','Seuss Fluff','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (86,'2021-05-04 14:05:10.662579','68','Snowman','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (87,'2021-05-04 14:05:36.749768','69','Strawberry','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (88,'2021-05-04 14:07:23.480904','70','Mernicorn','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (89,'2021-05-04 14:07:54.975689','71','Unicorn','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (90,'2021-05-04 14:08:46.225917','72','Valentine''s Day XOXO','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (91,'2021-05-04 14:10:41.354818','73','Velvet Christmas','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (92,'2021-05-04 14:11:11.449420','74','XOXO','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (93,'2021-05-04 14:11:47.998112','75','Kisses XOXO','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (94,'2021-05-04 14:12:40.945513','76','American Layered Earrings','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (95,'2021-05-04 14:13:21.045203','77','Floral Striped Teardrop Earrings','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (96,'2021-05-04 14:14:13.150200','78','Juniper Pom Pom Earrings','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (97,'2021-05-04 14:14:39.266983','79','Leopard Striped Layered Earrings','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (98,'2021-05-04 14:15:12.420535','80','Softball Teardrop Earrings','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (99,'2021-05-04 14:16:22.445798','81','Pearl necklace','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (100,'2021-05-04 14:16:57.630437','82','Christmas Leopard Necklace','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (101,'2021-05-04 14:17:29.190305','83','Hocus Pocus Necklace','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (102,'2021-05-04 14:17:56.680989','84','Lions Necklace','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (103,'2021-05-04 14:18:42.912788','85','XOXO Necklace','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (104,'2021-05-04 14:19:25.275437','86','Black & Gold Geo','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (105,'2021-05-04 14:21:41.445056','87','Yellowstone','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (106,'2021-05-04 14:22:00.503891','88','tiktok','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (107,'2021-05-04 14:22:26.369634','89','Lions','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (108,'2021-05-04 14:23:19.721907','90','Harry Potter Books','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (109,'2021-05-04 14:23:54.289712','91','Bunny Bummies','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (110,'2021-05-04 14:24:57.714614','92','I''m Extra Guac Too','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (111,'2021-05-04 14:25:38.635730','93','Thelma & Louise','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (112,'2021-05-04 14:26:13.288543','94','Yellowstone Outfit','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (113,'2021-05-04 14:26:54.590199','95','Did You Dye Bunny Onesie','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (114,'2021-05-04 14:27:36.064527','96','Lions Leopard Outfit','[{"added": {}}]',15,1,1);
INSERT INTO "django_admin_log" VALUES (115,'2021-05-06 18:40:36.575053','42','1 of Rainbow Mama Tee','[{"added": {}}]',14,1,1);
INSERT INTO "django_admin_log" VALUES (116,'2021-05-06 18:41:00.982155','2','testusername','',13,1,3);
INSERT INTO "django_admin_log" VALUES (117,'2021-05-06 18:41:07.773911','1','admin','',13,1,3);
INSERT INTO "django_admin_log" VALUES (118,'2021-05-06 18:42:34.522838','43','1 of Mama Vibes','[{"added": {}}]',14,1,1);
INSERT INTO "django_admin_log" VALUES (119,'2021-05-06 18:42:53.102605','3','admin','[{"added": {}}]',13,1,1);
INSERT INTO "django_admin_log" VALUES (120,'2021-05-06 18:43:19.860652','3','admin','',13,1,3);
INSERT INTO "django_admin_log" VALUES (121,'2021-05-07 14:50:02.054738','44','1 of Mama Vibes','[{"added": {}}]',14,1,1);
INSERT INTO "django_admin_log" VALUES (122,'2021-05-07 14:50:09.815843','4','testusername','[{"added": {}}]',13,1,1);
INSERT INTO "django_admin_log" VALUES (123,'2021-05-07 15:03:42.753376','45','1 of Mama Floral','[{"added": {}}]',14,1,1);
INSERT INTO "django_admin_log" VALUES (124,'2021-05-07 15:03:49.301776','5','admin','[{"added": {}}]',13,1,1);
INSERT INTO "django_admin_log" VALUES (125,'2021-05-07 15:04:42.588369','45','1 of Mama Floral','',14,1,3);
INSERT INTO "django_admin_log" VALUES (126,'2021-05-07 15:04:42.718007','44','1 of Mama Vibes','',14,1,3);
INSERT INTO "django_admin_log" VALUES (127,'2021-05-07 15:04:42.826345','43','1 of Mama Vibes','',14,1,3);
INSERT INTO "django_admin_log" VALUES (128,'2021-05-07 15:04:42.901146','42','1 of Rainbow Mama Tee','',14,1,3);
INSERT INTO "django_admin_log" VALUES (129,'2021-05-07 15:04:59.068407','46','1 of Love','[{"added": {}}]',14,1,1);
INSERT INTO "django_admin_log" VALUES (130,'2021-05-07 15:05:02.694643','5','admin','[{"changed": {"fields": ["items"]}}]',13,1,2);
INSERT INTO "django_admin_log" VALUES (131,'2021-05-08 20:05:15.744226','4','Mama Brushstrokes','[{"changed": {"fields": ["discount_price"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (132,'2021-05-12 15:57:42.181389','1','FIRST_TIMER','[{"added": {}}]',18,1,1);
INSERT INTO "django_admin_log" VALUES (133,'2021-05-12 21:12:22.897467','5','admin','[{"changed": {"fields": ["refund_requested"]}}]',13,1,2);
INSERT INTO "django_admin_log" VALUES (134,'2021-05-12 21:16:21.797484','4','testusername','[{"changed": {"fields": ["items", "in_process"]}}]',13,1,2);
INSERT INTO "django_admin_log" VALUES (135,'2021-05-15 02:10:14.201087','1','FIRST_TIMER','',18,1,3);
INSERT INTO "django_admin_log" VALUES (136,'2021-05-15 02:12:23.594097','16','Go Jesus...it''s the Third Day','[{"changed": {"fields": ["image", "shirt_color"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (137,'2021-05-15 02:13:54.404903','34','Halloween Piggy Set','[{"changed": {"fields": ["image", "available"]}}]',15,1,2);
INSERT INTO "django_admin_log" VALUES (138,'2021-05-15 02:21:30.889993','2','TEST_COUPON','[{"added": {}}]',18,1,1);
INSERT INTO "django_admin_log" VALUES (139,'2021-05-15 17:38:40.088211','4','Iamspecial','',4,1,3);
INSERT INTO "django_admin_log" VALUES (140,'2021-05-15 17:38:40.180964','3','testing','',4,1,3);
INSERT INTO "django_admin_log" VALUES (141,'2021-05-15 17:38:40.256760','2','testusername','',4,1,3);
INSERT INTO "django_admin_log" VALUES (142,'2021-05-15 17:47:32.657806','2','TEST_COUPON','',18,1,3);
INSERT INTO "django_admin_log" VALUES (143,'2021-05-15 18:23:45.822525','3','TEST_COUPON','[{"added": {}}]',18,1,1);
INSERT INTO "django_admin_log" VALUES (144,'2021-05-15 21:58:26.641207','9','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (145,'2021-05-15 21:58:26.749337','8','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (146,'2021-05-15 21:58:26.825134','7','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (147,'2021-05-15 21:58:26.898938','6','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (148,'2021-05-15 21:58:26.983759','5','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (149,'2021-05-15 21:58:27.074900','4','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (150,'2021-05-15 21:58:27.170855','3','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (151,'2021-05-15 21:58:27.291534','2','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (152,'2021-05-15 21:58:27.386278','1','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (153,'2021-05-15 21:58:33.461619','10','admin','',20,1,3);
INSERT INTO "django_admin_log" VALUES (154,'2021-05-15 21:59:09.428410','11','admin','[{"added": {}}]',20,1,1);
INSERT INTO "django_admin_log" VALUES (155,'2021-05-15 21:59:28.113199','12','admin','[{"added": {}}]',20,1,1);
INSERT INTO "django_content_type" VALUES (1,'admin','logentry');
INSERT INTO "django_content_type" VALUES (2,'auth','permission');
INSERT INTO "django_content_type" VALUES (3,'auth','group');
INSERT INTO "django_content_type" VALUES (4,'auth','user');
INSERT INTO "django_content_type" VALUES (5,'contenttypes','contenttype');
INSERT INTO "django_content_type" VALUES (6,'sessions','session');
INSERT INTO "django_content_type" VALUES (7,'sites','site');
INSERT INTO "django_content_type" VALUES (8,'account','emailaddress');
INSERT INTO "django_content_type" VALUES (9,'account','emailconfirmation');
INSERT INTO "django_content_type" VALUES (10,'socialaccount','socialaccount');
INSERT INTO "django_content_type" VALUES (11,'socialaccount','socialapp');
INSERT INTO "django_content_type" VALUES (12,'socialaccount','socialtoken');
INSERT INTO "django_content_type" VALUES (13,'hbc_app','order');
INSERT INTO "django_content_type" VALUES (14,'hbc_app','orderitem');
INSERT INTO "django_content_type" VALUES (15,'hbc_app','item');
INSERT INTO "django_content_type" VALUES (16,'hbc_app','checkoutaddress');
INSERT INTO "django_content_type" VALUES (17,'hbc_app','billingaddress');
INSERT INTO "django_content_type" VALUES (18,'hbc_app','coupon');
INSERT INTO "django_content_type" VALUES (19,'hbc_app','refund');
INSERT INTO "django_content_type" VALUES (20,'hbc_app','address');
INSERT INTO "django_content_type" VALUES (21,'hbc_app','payment');
INSERT INTO "django_content_type" VALUES (22,'hbc_app','category');
INSERT INTO "auth_permission" VALUES (1,1,'add_logentry','Can add log entry');
INSERT INTO "auth_permission" VALUES (2,1,'change_logentry','Can change log entry');
INSERT INTO "auth_permission" VALUES (3,1,'delete_logentry','Can delete log entry');
INSERT INTO "auth_permission" VALUES (4,1,'view_logentry','Can view log entry');
INSERT INTO "auth_permission" VALUES (5,2,'add_permission','Can add permission');
INSERT INTO "auth_permission" VALUES (6,2,'change_permission','Can change permission');
INSERT INTO "auth_permission" VALUES (7,2,'delete_permission','Can delete permission');
INSERT INTO "auth_permission" VALUES (8,2,'view_permission','Can view permission');
INSERT INTO "auth_permission" VALUES (9,3,'add_group','Can add group');
INSERT INTO "auth_permission" VALUES (10,3,'change_group','Can change group');
INSERT INTO "auth_permission" VALUES (11,3,'delete_group','Can delete group');
INSERT INTO "auth_permission" VALUES (12,3,'view_group','Can view group');
INSERT INTO "auth_permission" VALUES (13,4,'add_user','Can add user');
INSERT INTO "auth_permission" VALUES (14,4,'change_user','Can change user');
INSERT INTO "auth_permission" VALUES (15,4,'delete_user','Can delete user');
INSERT INTO "auth_permission" VALUES (16,4,'view_user','Can view user');
INSERT INTO "auth_permission" VALUES (17,5,'add_contenttype','Can add content type');
INSERT INTO "auth_permission" VALUES (18,5,'change_contenttype','Can change content type');
INSERT INTO "auth_permission" VALUES (19,5,'delete_contenttype','Can delete content type');
INSERT INTO "auth_permission" VALUES (20,5,'view_contenttype','Can view content type');
INSERT INTO "auth_permission" VALUES (21,6,'add_session','Can add session');
INSERT INTO "auth_permission" VALUES (22,6,'change_session','Can change session');
INSERT INTO "auth_permission" VALUES (23,6,'delete_session','Can delete session');
INSERT INTO "auth_permission" VALUES (24,6,'view_session','Can view session');
INSERT INTO "auth_permission" VALUES (25,7,'add_site','Can add site');
INSERT INTO "auth_permission" VALUES (26,7,'change_site','Can change site');
INSERT INTO "auth_permission" VALUES (27,7,'delete_site','Can delete site');
INSERT INTO "auth_permission" VALUES (28,7,'view_site','Can view site');
INSERT INTO "auth_permission" VALUES (29,8,'add_emailaddress','Can add email address');
INSERT INTO "auth_permission" VALUES (30,8,'change_emailaddress','Can change email address');
INSERT INTO "auth_permission" VALUES (31,8,'delete_emailaddress','Can delete email address');
INSERT INTO "auth_permission" VALUES (32,8,'view_emailaddress','Can view email address');
INSERT INTO "auth_permission" VALUES (33,9,'add_emailconfirmation','Can add email confirmation');
INSERT INTO "auth_permission" VALUES (34,9,'change_emailconfirmation','Can change email confirmation');
INSERT INTO "auth_permission" VALUES (35,9,'delete_emailconfirmation','Can delete email confirmation');
INSERT INTO "auth_permission" VALUES (36,9,'view_emailconfirmation','Can view email confirmation');
INSERT INTO "auth_permission" VALUES (37,10,'add_socialaccount','Can add social account');
INSERT INTO "auth_permission" VALUES (38,10,'change_socialaccount','Can change social account');
INSERT INTO "auth_permission" VALUES (39,10,'delete_socialaccount','Can delete social account');
INSERT INTO "auth_permission" VALUES (40,10,'view_socialaccount','Can view social account');
INSERT INTO "auth_permission" VALUES (41,11,'add_socialapp','Can add social application');
INSERT INTO "auth_permission" VALUES (42,11,'change_socialapp','Can change social application');
INSERT INTO "auth_permission" VALUES (43,11,'delete_socialapp','Can delete social application');
INSERT INTO "auth_permission" VALUES (44,11,'view_socialapp','Can view social application');
INSERT INTO "auth_permission" VALUES (45,12,'add_socialtoken','Can add social application token');
INSERT INTO "auth_permission" VALUES (46,12,'change_socialtoken','Can change social application token');
INSERT INTO "auth_permission" VALUES (47,12,'delete_socialtoken','Can delete social application token');
INSERT INTO "auth_permission" VALUES (48,12,'view_socialtoken','Can view social application token');
INSERT INTO "auth_permission" VALUES (49,13,'add_order','Can add order');
INSERT INTO "auth_permission" VALUES (50,13,'change_order','Can change order');
INSERT INTO "auth_permission" VALUES (51,13,'delete_order','Can delete order');
INSERT INTO "auth_permission" VALUES (52,13,'view_order','Can view order');
INSERT INTO "auth_permission" VALUES (53,14,'add_orderitem','Can add order item');
INSERT INTO "auth_permission" VALUES (54,14,'change_orderitem','Can change order item');
INSERT INTO "auth_permission" VALUES (55,14,'delete_orderitem','Can delete order item');
INSERT INTO "auth_permission" VALUES (56,14,'view_orderitem','Can view order item');
INSERT INTO "auth_permission" VALUES (57,15,'add_item','Can add item');
INSERT INTO "auth_permission" VALUES (58,15,'change_item','Can change item');
INSERT INTO "auth_permission" VALUES (59,15,'delete_item','Can delete item');
INSERT INTO "auth_permission" VALUES (60,15,'view_item','Can view item');
INSERT INTO "auth_permission" VALUES (61,16,'add_checkoutaddress','Can add checkout address');
INSERT INTO "auth_permission" VALUES (62,16,'change_checkoutaddress','Can change checkout address');
INSERT INTO "auth_permission" VALUES (63,16,'delete_checkoutaddress','Can delete checkout address');
INSERT INTO "auth_permission" VALUES (64,16,'view_checkoutaddress','Can view checkout address');
INSERT INTO "auth_permission" VALUES (65,17,'add_billingaddress','Can add billing address');
INSERT INTO "auth_permission" VALUES (66,17,'change_billingaddress','Can change billing address');
INSERT INTO "auth_permission" VALUES (67,17,'delete_billingaddress','Can delete billing address');
INSERT INTO "auth_permission" VALUES (68,17,'view_billingaddress','Can view billing address');
INSERT INTO "auth_permission" VALUES (69,18,'add_coupon','Can add coupon');
INSERT INTO "auth_permission" VALUES (70,18,'change_coupon','Can change coupon');
INSERT INTO "auth_permission" VALUES (71,18,'delete_coupon','Can delete coupon');
INSERT INTO "auth_permission" VALUES (72,18,'view_coupon','Can view coupon');
INSERT INTO "auth_permission" VALUES (73,19,'add_refund','Can add refund');
INSERT INTO "auth_permission" VALUES (74,19,'change_refund','Can change refund');
INSERT INTO "auth_permission" VALUES (75,19,'delete_refund','Can delete refund');
INSERT INTO "auth_permission" VALUES (76,19,'view_refund','Can view refund');
INSERT INTO "auth_permission" VALUES (77,20,'add_address','Can add address');
INSERT INTO "auth_permission" VALUES (78,20,'change_address','Can change address');
INSERT INTO "auth_permission" VALUES (79,20,'delete_address','Can delete address');
INSERT INTO "auth_permission" VALUES (80,20,'view_address','Can view address');
INSERT INTO "auth_permission" VALUES (81,21,'add_payment','Can add payment');
INSERT INTO "auth_permission" VALUES (82,21,'change_payment','Can change payment');
INSERT INTO "auth_permission" VALUES (83,21,'delete_payment','Can delete payment');
INSERT INTO "auth_permission" VALUES (84,21,'view_payment','Can view payment');
INSERT INTO "auth_permission" VALUES (85,22,'add_category','Can add category');
INSERT INTO "auth_permission" VALUES (86,22,'change_category','Can change category');
INSERT INTO "auth_permission" VALUES (87,22,'delete_category','Can delete category');
INSERT INTO "auth_permission" VALUES (88,22,'view_category','Can view category');
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$150000$XErJz2hlR1q0$KTsldW0B9VC1bcdObDRoMmL57PXIPDGWUvBPpHxXdrA=','2021-05-16 18:54:25.806011',1,'admin','','',1,1,'2021-04-26 12:31:37.939930','');
INSERT INTO "django_session" VALUES ('i22xfjhzsn6ioddql2zp9bd12bu599fe','OGI3NDg0OTdkMTJhOWEwM2M4MTRiYTIwZGNmMTYyNDJkMzVmYzdmMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJmNzcyMmZhYWRkYjkxZjAwZGFhMGNkOWJlZjBkNmM5NGM1NDVhZDMwIn0=','2021-05-30 18:54:25.897784');
INSERT INTO "django_site" VALUES (1,'example.com','example.com');
INSERT INTO "hbc_app_item" VALUES (1,'Rainbow Mama Tee',20.0,NULL,'T','Purple bleached rainbow mama tee- can customize shirt to any color you like. Please write a comment in the notes in checkout indicating which shirt color you would like.','2021-04-26 16:02:58.583985','2021-05-03 16:19:13.376695','mama_tee.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (2,'Rainbow Mini Tee',15.0,NULL,'T','Purple Bleached Rainbow Mini Tee- pairs perfectly with our purple rainbow mama tee! Or customize to your liking- please make a note in the checkout section which color you would like!','2021-04-27 13:08:09.776564','2021-05-03 16:19:01.153320','prp_mini_tee.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (3,'Mama Floral',20.0,NULL,'T','Mama with floral design- customize with any color shirt you like!','2021-04-29 14:41:59.722414','2021-05-03 16:18:34.454429','mama_floral.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (4,'Mama Brushstrokes',20.0,15.0,'T','Leopard, plaid, zebra, colored brushstrokes behind Mama- customize your brushstrokes and/or color shirt','2021-04-29 14:43:16.956912','2021-05-08 20:05:15.742231','mama_brushstrokes.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (5,'Lucky Mama',20.0,NULL,'T','Green Lucky Mama with shamrocks- customize how you want!','2021-04-29 14:43:46.960026','2021-05-03 16:18:04.500577','lucky_mama.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (6,'Mama Vibes',25.0,NULL,'T','Show your mama vibes with cute tee!','2021-04-29 14:46:37.415353','2021-05-03 16:17:54.061596','mama_vibes.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (7,'Mama Tried',20.0,NULL,'T','Don''t we all try!?','2021-04-29 14:47:15.400582','2021-05-03 16:17:41.308260','mama_tried.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (8,'Love',20.0,NULL,'T','Love leopard tee- cute for anywhere, anytime!','2021-04-29 14:47:47.512375','2021-05-03 16:17:31.200555','love_leopard_tee.jpg','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (9,'Ew Cupid',15.0,NULL,'T','Ew, cupid!','2021-04-29 14:48:14.770109','2021-05-03 16:17:18.989149','ew_cupid_tee.jpg','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (10,'But Did You Dye?',25.0,NULL,'T','You need this for Easter!','2021-04-29 14:48:47.111078','2021-05-03 16:17:09.182902','but_did_you_dye_eggs.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (11,'Tacos Are My Valentine',20.0,NULL,'T','Truth!','2021-04-29 14:49:24.545022','2021-05-03 16:16:52.516778','tacos_are_my_valentine_tee.jpg','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (12,'So Eggstra',25.0,NULL,'T','Cute Easter themed shirt! Customize to have your mini match you!','2021-04-29 14:50:02.441520','2021-05-03 16:16:41.105530','dark_pink_eggstra.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (13,'(Nurse) I''ll Be There For You',25.0,NULL,'T','Cute "Friends" theme for our beloved nurses!','2021-04-29 14:50:58.311959','2021-05-03 16:16:11.730829','nurse_ill_be_there_for_you.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (14,'Shenanigans Expert',25.0,NULL,'T','Get one for your mini too!','2021-04-29 14:51:51.147740','2021-05-03 16:15:52.543656','shenanigans_expert1.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (15,'But Did You Dye? (Bunny)',20.0,NULL,'T','Choose your color!','2021-05-04 12:53:07.697551','2021-05-04 12:53:07.697551','bright_blue_did_you_dye_bunny.png','Heather Galapagos Blue',1);
INSERT INTO "hbc_app_item" VALUES (16,'Go Jesus...it''s the Third Day',20.0,NULL,'T','Go Jesus...it''s the Third Day! Fun Easter shirt for all ages! Choose your color!','2021-05-04 12:54:17.995904','2021-05-15 02:12:23.592102','dark_blue_jesus_third_day.png','Heather Navy',1);
INSERT INTO "hbc_app_item" VALUES (17,'Leopard Bunny Ears',20.0,NULL,'T','Cute Easter shirt','2021-05-04 12:55:29.997555','2021-05-04 12:55:29.998552','coral_leopard_bunny_ears.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (18,'Leopard Cross',20.0,NULL,'T','Leopard Cross tee- cute for any occasion!','2021-05-04 12:56:36.902932','2021-05-04 12:56:36.902932','coral_leopard_cross.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (19,'Hip Hop',20.0,NULL,'T','Hip Hop Easter shirt','2021-05-04 12:57:37.637105','2021-05-04 12:57:37.637105','dark_pink_hip_hop.png','Heather Berry',1);
INSERT INTO "hbc_app_item" VALUES (20,'Kissing 100 Days Goodbye',20.0,NULL,'T','Say Goodbye to the last 100 days! You did it Mama!','2021-05-04 12:59:52.281977','2021-05-04 13:00:07.643322','kissing_100_days_goodbye_tee.png','White',1);
INSERT INTO "hbc_app_item" VALUES (21,'Raising My Tribe on Jesus Vibes',20.0,NULL,'T','Leopard cross "Raising my tribe on Jesus Vibes"','2021-05-04 13:01:47.335912','2021-05-04 13:01:47.335912','leopard_pink_raising_tribe_jesus_vibes.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (22,'He Is Risen',20.0,NULL,'T','Leopard cross "He is Risen"','2021-05-04 13:02:30.347123','2021-05-04 13:02:30.347123','pink_leopard_he_is_risen.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (23,'Black with Pearls',8.0,NULL,'CB','Dress your lil lady up with this classic and adorable black with pearls cloth bow! Add the matching necklace for $4 more.','2021-05-04 13:11:30.458098','2021-05-04 13:14:47.361294','black_with_pearls_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (24,'Rust Head Wrap Fluff',8.0,NULL,'HW','Cute for any age!','2021-05-04 13:19:12.825588','2021-05-04 13:19:12.825588','burnt_orange_tail_headwrap.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (25,'Candy Cane Cloth Bow',5.0,NULL,'CB','Get in the spirit of Christmas with this cute Candy Cane cloth bow','2021-05-04 13:21:33.510985','2021-05-04 13:21:33.510985','candycane_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (26,'Christmas Plaid Center',8.0,NULL,'CB','Cute Christmas bow with classic plaid and added layers','2021-05-04 13:22:48.422815','2021-05-04 13:22:48.422815','christmas_plaidcenter_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (27,'Christmas Ribbon Bow Piggies',8.0,NULL,'RB','Piggie Christmas bows','2021-05-04 13:25:11.214108','2021-05-04 13:25:11.214108','christmas_ribbon_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (28,'Classic Red Plaid Cloth Bow',5.0,NULL,'CB','Classic Plaid Cloth Bow','2021-05-04 13:26:11.688949','2021-05-04 13:26:11.688949','classic_plaid_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (29,'Classic Plaid Poinsettia',5.0,NULL,'RB','Classic Plaid Poinsettia ribbon bow','2021-05-04 13:27:21.644793','2021-05-04 13:27:21.644793','classic_plaid_poinsetta_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (30,'Farm Market Christmas',5.0,NULL,'CB','Farm Market Christmas','2021-05-04 13:27:56.085355','2021-05-04 13:27:56.086352','farm_market_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (31,'Layered Floral Pumpkin Leather Bow Set',10.0,NULL,'LB','Layered Floral Pumpkin leather bow set','2021-05-04 13:29:12.756798','2021-05-04 13:29:12.756798','floral_pumpkin_leather_bow_set.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (32,'Ghostbuster Piggies',8.0,NULL,'CB','Who ya gonna call? Ghostbusters! Must have piggy set!','2021-05-04 13:30:29.603371','2021-05-04 13:30:29.603371','ghostbuster_cloth_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (33,'Grinch Christmas',5.0,NULL,'CB','Well, in Whoville they say that the Grinch’s small heart grew three sizes that day.” – Dr. Suess','2021-05-04 13:33:36.038690','2021-05-04 13:33:36.038690','grinch_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (34,'Halloween Piggy Set',8.0,NULL,'LB','Halloween Piggy Set','2021-05-04 13:34:10.315353','2021-05-15 02:13:54.402908','halloween_bows.jpg',NULL,0);
INSERT INTO "hbc_app_item" VALUES (35,'Layered Black Glitter Halloween Piggy Set',8.0,NULL,'LB','Layered Black Glitter Halloween Piggy Set','2021-05-04 13:35:11.344174','2021-05-04 13:35:11.344174','halloween_leather_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (36,'Layered Striped Halloween Ribbon Bow',5.0,NULL,'RB','Cute layered black and white stripe Halloween ribbon bow','2021-05-04 13:36:07.042973','2021-05-04 13:36:07.042973','halloween_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (37,'Hello Love Ribbon Bow',5.0,NULL,'RB','Add the matching necklace for $4 more','2021-05-04 13:36:59.254927','2021-05-04 13:36:59.254927','hello_love_ribbon_bow_1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (38,'Hocus Pocus Cloth Bow',5.0,NULL,'CB','Add the matching necklace for $4 more','2021-05-04 13:37:30.886453','2021-05-04 13:37:30.886453','hocus_pocus_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (39,'Icecream Cloth Bow',5.0,NULL,'CB','You scream, I scream, we all scream for icecream!','2021-05-04 13:38:17.596542','2021-05-04 13:38:17.596542','icecream_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (40,'Harry Potter Cloth Bow',5.0,NULL,'CB','Harry Potter Cloth Bow or Head Wrap','2021-05-04 13:39:51.567366','2021-05-04 13:39:51.568364','IMG_6630.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (41,'Sunflower Striped Cloth Bow',5.0,NULL,'CB','Choose your choice of Headwrap, head wrap, or piggy set.','2021-05-04 13:41:16.320353','2021-05-04 13:41:16.320353','IMG_6633.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (42,'Fiesta Cloth Piggy Set',8.0,NULL,'CB','Celebrate with these festive cloth piggies','2021-05-04 13:42:38.591811','2021-05-04 13:42:38.591811','IMG_6646.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (43,'American Stars & Stripes Bows',8.0,NULL,'CB','Choose your style of head wrap, piggies, or single cloth bow.','2021-05-04 13:46:15.209242','2021-05-04 13:46:15.209242','IMG_6677-2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (44,'Multi-print Cloth Bows',5.0,NULL,'CB','Head wrap or single cloth bow','2021-05-04 13:47:14.530757','2021-05-04 13:47:14.530757','IMG_6681.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (45,'Leopard Sunflower',5.0,NULL,'CB','Headwrap or single bow','2021-05-04 13:48:24.913649','2021-05-04 13:48:24.913649','IMG_6690-2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (46,'Puzzle Pieces',5.0,NULL,'CB','Puzzle pieces wrap or single cloth bow','2021-05-04 13:49:03.324910','2021-05-04 13:49:03.324910','IMG_6692-2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (47,'Neon Yellow Cloth Bows',8.0,NULL,'CB','Piggies, head wrap, or single bow','2021-05-04 13:49:40.495147','2021-05-04 13:49:40.495147','IMG_6700.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (48,'Layered Kisses Ribbon Bow',8.0,NULL,'RB','Perfect Valentine''s Day Ribbon Bow','2021-05-04 13:50:22.327977','2021-05-04 13:50:22.327977','kisses_purple_layered_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (49,'Leopard Christmas Bow',5.0,NULL,'RB','Leopard Christmas Bow','2021-05-04 13:50:52.086956','2021-05-04 13:50:52.086956','leopard_christmas_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (50,'Leopard Lions Turban Wrap',5.0,NULL,'HW','Support your Durant Lions with this cute Leopard Lions Turban Wrap. Or customize to your school- just message me!','2021-05-04 13:52:05.567723','2021-05-04 13:52:05.567723','lions_leopard_headwrap.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (51,'Leopard Lions Ribbon Bow',5.0,NULL,'RB','Show your school spirit with this cute layered ribbon bow. Add the matching necklace for $4 more.','2021-05-04 13:52:50.384646','2021-05-04 13:52:50.384646','lions_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (52,'Valentine''s Love Layered Bow',8.0,NULL,'RB','Perfect Valentine''s Day Layered Ribbon Bow','2021-05-04 13:53:38.347596','2021-05-04 13:53:38.347596','love_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (53,'Happy New Year',5.0,NULL,'CB','Ring in the new year with this adorable Happy New Year cloth bow','2021-05-04 13:54:19.845678','2021-05-04 13:54:19.845678','new_year_black_gold_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (54,'Ornament Christmas',5.0,NULL,'CB','Ornament Christmas cloth bow','2021-05-04 13:54:48.337061','2021-05-04 13:54:48.337061','ornament_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (55,'Kisses',5.0,NULL,'RB','Kisses ribbon bow','2021-05-04 13:55:26.041846','2021-05-04 13:55:26.041846','pink_kisses_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (56,'Purple Glitter Pumpkin',8.0,NULL,'LB','Make it a piggy set if you want','2021-05-04 13:56:36.308925','2021-05-04 13:56:36.308925','pumpkin_purple_glitter_leather_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (57,'Queen',8.0,NULL,'RB','Queen red and black layered ribbon bow','2021-05-04 13:57:20.692970','2021-05-04 13:57:20.692970','queen_red_black_ribbon_bow1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (58,'Flannel Christmas Piggy Set',8.0,NULL,'LB','Flannel Chritmas Piggy Set','2021-05-04 13:58:27.845353','2021-05-04 13:58:27.845353','red_black_flannel_leather_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (59,'Red Glitter',8.0,NULL,'LB','Red Glitter Piggy Set','2021-05-04 13:59:00.575867','2021-05-04 13:59:00.575867','red_glitter_leather_bows_2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (60,'Red Sequin',8.0,NULL,'CB','Cute for any occasion','2021-05-04 13:59:38.043560','2021-05-04 13:59:38.043560','red_sequin_cloth_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (61,'Salmon Pink School',5.0,NULL,'CB','School cloth bow in salmon pink color','2021-05-04 14:00:32.750026','2021-05-04 14:00:32.750026','salmon_pink_school_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (62,'Santa Buckle Piggy Set',8.0,NULL,'LB','Santa Buckle Piggy Set','2021-05-04 14:01:05.276286','2021-05-04 14:01:05.276286','santa_christmas_leather_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (63,'Santa Leopard',5.0,NULL,'CB','Add the matching necklace for $4','2021-05-04 14:01:45.858967','2021-05-04 14:01:45.858967','santa_leopard_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (64,'School',5.0,NULL,'RB','Classic school ribbon bow','2021-05-04 14:02:19.652055','2021-05-04 14:02:19.652055','school_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (65,'School Spirit',5.0,NULL,'RB','Show your school spirit with this cute black and gold ribbon bow- or customize anyhow you like!','2021-05-04 14:03:12.080807','2021-05-04 14:03:12.080807','school_spirit_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (66,'Red & Black School Spirit',5.0,NULL,'RB','Another school spirit bow- customize to your liking!','2021-05-04 14:03:51.914672','2021-05-04 14:03:51.914672','school_spirit_ribbon_bow1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (67,'Seuss Fluff',5.0,NULL,'RB','Show your love for Dr. Seuss with this adorable and fluffy ribbon bow','2021-05-04 14:04:42.015038','2021-05-04 14:04:42.015038','seuss_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (68,'Snowman',5.0,NULL,'RB','Snowman ribbon bow','2021-05-04 14:05:10.646050','2021-05-04 14:05:10.646050','snowman_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (69,'Strawberry',5.0,NULL,'CB','Strawberry cloth bow','2021-05-04 14:05:36.748780','2021-05-04 14:05:36.748780','strawberry_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (70,'Mernicorn',8.0,NULL,'LB','Unimaid? Mernicorn? Whatever you like...the magic is all there! Bow or headband style','2021-05-04 14:07:23.470930','2021-05-04 14:07:23.470930','unicorn_mermaid_headband_or_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (71,'Unicorn',5.0,NULL,'RB','Pink unicorn ribbon bow','2021-05-04 14:07:54.960999','2021-05-04 14:07:54.960999','unicorn_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (72,'Valentine''s Day XOXO',8.0,NULL,'HW','Adorable Valentine''s Day XOXO Head Wrap','2021-05-04 14:08:46.223923','2021-05-04 14:08:46.223923','valentines_day_xoxo_set.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (73,'Velvet Christmas',5.0,NULL,'CB','Velvety soft Christmas bow','2021-05-04 14:10:41.351826','2021-05-04 14:10:41.351826','velvet_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (74,'XOXO',5.0,NULL,'CB','XOXO cloth bow','2021-05-04 14:11:11.447424','2021-05-04 14:11:11.447424','xoxo_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (75,'Kisses XOXO',5.0,NULL,'HW','Kisses XOXO cloth bow','2021-05-04 14:11:47.984149','2021-05-04 14:11:47.984149','xoxo_cloth_headwrap1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (76,'American Layered Earrings',6.0,NULL,'E','American layered leather earrings','2021-05-04 14:12:40.904623','2021-05-04 14:12:40.904623','american_layered_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (77,'Floral Striped Teardrop Earrings',6.0,NULL,'E','Floral Striped Teardrop Earrings','2021-05-04 14:13:21.043210','2021-05-04 14:13:21.043210','floral_striped_teardrop_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (78,'Juniper Pom Pom Earrings',6.0,NULL,'E','Juniper Pom Pom Earrings','2021-05-04 14:14:13.149114','2021-05-04 14:14:13.149114','green_pompom_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (79,'Leopard Striped Layered Earrings',6.0,NULL,'E','Leopard Striped Layered Earrings','2021-05-04 14:14:39.250910','2021-05-04 14:14:39.250910','leopard_striped_layered_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (80,'Softball Teardrop Earrings',6.0,NULL,'E','Softball Teardrop Earrings','2021-05-04 14:15:12.388276','2021-05-04 14:15:12.388276','softball_teardrop_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (81,'Pearl necklace',4.0,NULL,'NCK','Pairs perfect with our black with pearls cloth bow','2021-05-04 14:16:22.444059','2021-05-04 14:16:22.444059','black_white_pearl_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (82,'Christmas Leopard Necklace',4.0,NULL,'NCK','pairs perfectly with our leopard santa bow','2021-05-04 14:16:57.628440','2021-05-04 14:16:57.628440','christmas_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (83,'Hocus Pocus Necklace',4.0,NULL,'NCK','Pairs perfectly with our hocus pocus cloth bow','2021-05-04 14:17:29.189086','2021-05-04 14:17:29.189086','hocus_pocus_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (84,'Lions Necklace',4.0,NULL,'NCK','Pairs perfectly with our Lions ribbon bow','2021-05-04 14:17:56.677998','2021-05-04 14:17:56.677998','lions_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (85,'XOXO Necklace',4.0,NULL,'NCK','Pairs perfectly with any of our valentine''s day bows','2021-05-04 14:18:42.911285','2021-05-04 14:18:42.911285','xoxo_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (86,'Black & Gold Geo',6.0,NULL,'PG','Adorable phone grip','2021-05-04 14:19:25.274439','2021-05-04 14:19:25.274439','black_gold_geo.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (87,'Yellowstone',6.0,NULL,'PG','“We’re with the Yellowstone. Nobody’s gonna mess with us”','2021-05-04 14:21:41.434082','2021-05-04 14:21:41.434082','yellowstone.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (88,'tiktok',6.0,NULL,'PG','TikTok phone grip','2021-05-04 14:22:00.502268','2021-05-04 14:22:00.502268','tiktok.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (89,'Lions',6.0,NULL,'PG','Customize to your own school','2021-05-04 14:22:26.367640','2021-05-04 14:22:26.367640','lions.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (90,'Harry Potter Books',10.0,NULL,'BC','Pairs perfectly with our Harry Potter cloth bows','2021-05-04 14:23:19.719911','2021-05-04 14:23:19.719911','books_baby_tee.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (91,'Bunny Bummies',8.0,NULL,'BC','Aren''t these adorable! Bunny tail is removeable','2021-05-04 14:23:54.266578','2021-05-04 14:23:54.266578','bunny_bummies.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (92,'I''m Extra Guac Too',15.0,NULL,'BC','Is your lil one EXTRA too??','2021-05-04 14:24:57.712959','2021-05-04 14:24:57.712959','extra_guac_print.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (93,'Thelma & Louise',24.0,NULL,'BC','Cutest Thelma and Louise I''ve ever seen!','2021-05-04 14:25:38.634735','2021-05-04 14:25:38.634735','thelma_louise_outfits.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (94,'Yellowstone Outfit',15.0,NULL,'BC','Bummies and crop top- adorable!','2021-05-04 14:26:13.278791','2021-05-04 14:26:13.278791','yellowstone_outfit.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (95,'Did You Dye Bunny Onesie',8.0,NULL,'BC','Customize to your liking','2021-05-04 14:26:54.537513','2021-05-04 14:26:54.537513','grey_did_you_dye_bunny_onesie.png',NULL,1);
INSERT INTO "hbc_app_item" VALUES (96,'Lions Leopard Outfit',15.0,NULL,'BC','Onesie and leopard bummies- customize to your liking','2021-05-04 14:27:36.048512','2021-05-04 14:27:36.048512','lions_leopard_print.jpg',NULL,1);
INSERT INTO "hbc_app_coupon" VALUES (3,'TEST_COUPON',10.0);
INSERT INTO "hbc_app_address" VALUES (11,'1234 Happy Street','1235','Happy','TX','US','75358','S',1,'2021-05-15 21:59:09.410430','2021-05-15 21:59:09.410430',1);
INSERT INTO "hbc_app_address" VALUES (12,'1234 Happy Street','123','Happy','TX','US','75358','B',1,'2021-05-15 21:59:28.097053','2021-05-15 21:59:28.097053',1);
INSERT INTO "hbc_app_order" VALUES (5,'2021-05-07 15:03:49.265874','2021-05-07 15:03:45',1,'2021-05-07 15:03:49.265874','2021-05-12 21:12:22.893474',1,NULL,NULL,0,0,1,0,1,'123',NULL,NULL);
INSERT INTO "hbc_app_order" VALUES (6,'2021-05-07 15:35:05.039299','2021-05-07 15:35:05.039299',0,'2021-05-07 15:35:05.039299','2021-05-15 22:01:02.796070',1,12,3,0,0,0,0,1,'123',11,NULL);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
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
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "account_emailconfirmation_email_address_id_5b7f8c58" ON "account_emailconfirmation" (
	"email_address_id"
);
CREATE INDEX IF NOT EXISTS "account_emailaddress_user_id_2c513194" ON "account_emailaddress" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq" ON "socialaccount_socialtoken" (
	"app_id",
	"account_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialapp_sites_socialapp_id_site_id_71a9a768_uniq" ON "socialaccount_socialapp_sites" (
	"socialapp_id",
	"site_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialapp_sites_socialapp_id_97fb6e7d" ON "socialaccount_socialapp_sites" (
	"socialapp_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialapp_sites_site_id_2579dee5" ON "socialaccount_socialapp_sites" (
	"site_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialtoken_account_id_951f210e" ON "socialaccount_socialtoken" (
	"account_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialtoken_app_id_636a42d7" ON "socialaccount_socialtoken" (
	"app_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialaccount_provider_uid_fc810c6e_uniq" ON "socialaccount_socialaccount" (
	"provider",
	"uid"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialaccount_user_id_8146e70c" ON "socialaccount_socialaccount" (
	"user_id"
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
