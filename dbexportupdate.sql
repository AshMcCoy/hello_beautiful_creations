BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
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
	FOREIGN KEY("order_id") REFERENCES "hbc_app_order"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("orderitem_id") REFERENCES "hbc_app_orderitem"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "hbc_app_item" (
	"id"	integer NOT NULL,
	"item_name"	varchar(100) NOT NULL,
	"price"	real NOT NULL,
	"discount_price"	real,
	"image"	varchar(100),
	"description"	text NOT NULL,
	"shirt_color"	varchar(50),
	"available"	bool NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"category_name_id"	integer,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("category_name_id") REFERENCES "hbc_app_category"("id") DEFERRABLE INITIALLY DEFERRED
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
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("coupon_id") REFERENCES "hbc_app_coupon"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("shipping_address_id") REFERENCES "hbc_app_address"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("billing_address_id") REFERENCES "hbc_app_address"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("payment_id") REFERENCES "hbc_app_payment"("id") DEFERRABLE INITIALLY DEFERRED
);
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$150000$XErJz2hlR1q0$KTsldW0B9VC1bcdObDRoMmL57PXIPDGWUvBPpHxXdrA=','2021-05-16 18:54:25.806011',1,'admin','','',1,1,'2021-04-26 12:31:37.939930','');
INSERT INTO "hbc_app_item" VALUES (1,'Rainbow Mama Tee',20.0,NULL,'Purple bleached rainbow mama tee- can customize shirt to any color you like. Please write a comment in the notes in checkout indicating which shirt color you would like.','2021-04-26 16:02:58.583985','2021-05-03 16:19:13.376695','mama_tee.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (2,'Rainbow Mini Tee',15.0,NULL,'Purple Bleached Rainbow Mini Tee- pairs perfectly with our purple rainbow mama tee! Or customize to your liking- please make a note in the checkout section which color you would like!','2021-04-27 13:08:09.776564','2021-05-03 16:19:01.153320','prp_mini_tee.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (3,'Mama Floral',20.0,NULL,'Mama with floral design- customize with any color shirt you like!','2021-04-29 14:41:59.722414','2021-05-03 16:18:34.454429','mama_floral.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (4,'Mama Brushstrokes',20.0,15.0,'Leopard, plaid, zebra, colored brushstrokes behind Mama- customize your brushstrokes and/or color shirt','2021-04-29 14:43:16.956912','2021-05-08 20:05:15.742231','mama_brushstrokes.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (5,'Lucky Mama',20.0,NULL,'Green Lucky Mama with shamrocks- customize how you want!','2021-04-29 14:43:46.960026','2021-05-03 16:18:04.500577','lucky_mama.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (6,'Mama Vibes',25.0,NULL,'Show your mama vibes with cute tee!','2021-04-29 14:46:37.415353','2021-05-03 16:17:54.061596','mama_vibes.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (7,'Mama Tried',20.0,NULL,'Don''t we all try!?','2021-04-29 14:47:15.400582','2021-05-03 16:17:41.308260','mama_tried.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (8,'Love',20.0,NULL,'Love leopard tee- cute for anywhere, anytime!','2021-04-29 14:47:47.512375','2021-05-03 16:17:31.200555','love_leopard_tee.jpg','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (9,'Ew Cupid',15.0,NULL,'Ew, cupid!','2021-04-29 14:48:14.770109','2021-05-03 16:17:18.989149','ew_cupid_tee.jpg','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (10,'But Did You Dye?',25.0,NULL,'You need this for Easter!','2021-04-29 14:48:47.111078','2021-05-03 16:17:09.182902','but_did_you_dye_eggs.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (11,'Tacos Are My Valentine',20.0,NULL,'Truth!','2021-04-29 14:49:24.545022','2021-05-03 16:16:52.516778','tacos_are_my_valentine_tee.jpg','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (12,'So Eggstra',25.0,NULL,'Cute Easter themed shirt! Customize to have your mini match you!','2021-04-29 14:50:02.441520','2021-05-03 16:16:41.105530','dark_pink_eggstra.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (13,'(Nurse) I''ll Be There For You',25.0,NULL,'Cute "Friends" theme for our beloved nurses!','2021-04-29 14:50:58.311959','2021-05-03 16:16:11.730829','nurse_ill_be_there_for_you.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (14,'Shenanigans Expert',25.0,NULL,'Get one for your mini too!','2021-04-29 14:51:51.147740','2021-05-03 16:15:52.543656','shenanigans_expert1.png','Dark Heather',1);
INSERT INTO "hbc_app_item" VALUES (15,'But Did You Dye? (Bunny)',20.0,NULL,'Choose your color!','2021-05-04 12:53:07.697551','2021-05-04 12:53:07.697551','bright_blue_did_you_dye_bunny.png','Heather Galapagos Blue',1);
INSERT INTO "hbc_app_item" VALUES (16,'Go Jesus...it''s the Third Day',20.0,NULL,'Go Jesus...it''s the Third Day! Fun Easter shirt for all ages! Choose your color!','2021-05-04 12:54:17.995904','2021-05-15 02:12:23.592102','dark_blue_jesus_third_day.png','Heather Navy',1);
INSERT INTO "hbc_app_item" VALUES (17,'Leopard Bunny Ears',20.0,NULL,'Cute Easter shirt','2021-05-04 12:55:29.997555','2021-05-04 12:55:29.998552','coral_leopard_bunny_ears.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (18,'Leopard Cross',20.0,NULL,'Leopard Cross tee- cute for any occasion!','2021-05-04 12:56:36.902932','2021-05-04 12:56:36.902932','coral_leopard_cross.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (19,'Hip Hop',20.0,NULL,'Hip Hop Easter shirt','2021-05-04 12:57:37.637105','2021-05-04 12:57:37.637105','dark_pink_hip_hop.png','Heather Berry',1);
INSERT INTO "hbc_app_item" VALUES (20,'Kissing 100 Days Goodbye',20.0,NULL,'Say Goodbye to the last 100 days! You did it Mama!','2021-05-04 12:59:52.281977','2021-05-04 13:00:07.643322','kissing_100_days_goodbye_tee.png','White',1);
INSERT INTO "hbc_app_item" VALUES (21,'Raising My Tribe on Jesus Vibes',20.0,NULL,'Leopard cross "Raising my tribe on Jesus Vibes"','2021-05-04 13:01:47.335912','2021-05-04 13:01:47.335912','leopard_pink_raising_tribe_jesus_vibes.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (22,'He Is Risen',20.0,NULL,'Leopard cross "He is Risen"','2021-05-04 13:02:30.347123','2021-05-04 13:02:30.347123','pink_leopard_he_is_risen.png','Heather Coral Silk',1);
INSERT INTO "hbc_app_item" VALUES (23,'Black with Pearls',8.0,NULL,'Dress your lil lady up with this classic and adorable black with pearls cloth bow! Add the matching necklace for $4 more.','2021-05-04 13:11:30.458098','2021-05-04 13:14:47.361294','black_with_pearls_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (24,'Rust Head Wrap Fluff',8.0,NULL,'Cute for any age!','2021-05-04 13:19:12.825588','2021-05-04 13:19:12.825588','burnt_orange_tail_headwrap.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (25,'Candy Cane Cloth Bow',5.0,NULL,'Get in the spirit of Christmas with this cute Candy Cane cloth bow','2021-05-04 13:21:33.510985','2021-05-04 13:21:33.510985','candycane_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (26,'Christmas Plaid Center',8.0,NULL,'Cute Christmas bow with classic plaid and added layers','2021-05-04 13:22:48.422815','2021-05-04 13:22:48.422815','christmas_plaidcenter_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (27,'Christmas Ribbon Bow Piggies',8.0,NULL,'Piggie Christmas bows','2021-05-04 13:25:11.214108','2021-05-04 13:25:11.214108','christmas_ribbon_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (28,'Classic Red Plaid Cloth Bow',5.0,NULL,'Classic Plaid Cloth Bow','2021-05-04 13:26:11.688949','2021-05-04 13:26:11.688949','classic_plaid_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (29,'Classic Plaid Poinsettia',5.0,NULL,'Classic Plaid Poinsettia ribbon bow','2021-05-04 13:27:21.644793','2021-05-04 13:27:21.644793','classic_plaid_poinsetta_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (30,'Farm Market Christmas',5.0,NULL,'Farm Market Christmas','2021-05-04 13:27:56.085355','2021-05-04 13:27:56.086352','farm_market_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (31,'Layered Floral Pumpkin Leather Bow Set',10.0,NULL,'Layered Floral Pumpkin leather bow set','2021-05-04 13:29:12.756798','2021-05-04 13:29:12.756798','floral_pumpkin_leather_bow_set.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (32,'Ghostbuster Piggies',8.0,NULL,'Who ya gonna call? Ghostbusters! Must have piggy set!','2021-05-04 13:30:29.603371','2021-05-04 13:30:29.603371','ghostbuster_cloth_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (33,'Grinch Christmas',5.0,NULL,'Well, in Whoville they say that the Grinch’s small heart grew three sizes that day.” – Dr. Suess','2021-05-04 13:33:36.038690','2021-05-04 13:33:36.038690','grinch_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (34,'Halloween Piggy Set',8.0,NULL,'Halloween Piggy Set','2021-05-04 13:34:10.315353','2021-05-15 02:13:54.402908','halloween_bows.jpg',NULL,0);
INSERT INTO "hbc_app_item" VALUES (35,'Layered Black Glitter Halloween Piggy Set',8.0,NULL,'Layered Black Glitter Halloween Piggy Set','2021-05-04 13:35:11.344174','2021-05-04 13:35:11.344174','halloween_leather_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (36,'Layered Striped Halloween Ribbon Bow',5.0,NULL,'Cute layered black and white stripe Halloween ribbon bow','2021-05-04 13:36:07.042973','2021-05-04 13:36:07.042973','halloween_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (37,'Hello Love Ribbon Bow',5.0,NULL,'Add the matching necklace for $4 more','2021-05-04 13:36:59.254927','2021-05-04 13:36:59.254927','hello_love_ribbon_bow_1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (38,'Hocus Pocus Cloth Bow',5.0,NULL,'Add the matching necklace for $4 more','2021-05-04 13:37:30.886453','2021-05-04 13:37:30.886453','hocus_pocus_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (39,'Icecream Cloth Bow',5.0,NULL,'You scream, I scream, we all scream for icecream!','2021-05-04 13:38:17.596542','2021-05-04 13:38:17.596542','icecream_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (40,'Harry Potter Cloth Bow',5.0,NULL,'Harry Potter Cloth Bow or Head Wrap','2021-05-04 13:39:51.567366','2021-05-04 13:39:51.568364','IMG_6630.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (41,'Sunflower Striped Cloth Bow',5.0,NULL,'Choose your choice of Headwrap, head wrap, or piggy set.','2021-05-04 13:41:16.320353','2021-05-04 13:41:16.320353','IMG_6633.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (42,'Fiesta Cloth Piggy Set',8.0,NULL,'Celebrate with these festive cloth piggies','2021-05-04 13:42:38.591811','2021-05-04 13:42:38.591811','IMG_6646.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (43,'American Stars & Stripes Bows',8.0,NULL,'Choose your style of head wrap, piggies, or single cloth bow.','2021-05-04 13:46:15.209242','2021-05-04 13:46:15.209242','IMG_6677-2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (44,'Multi-print Cloth Bows',5.0,NULL,'Head wrap or single cloth bow','2021-05-04 13:47:14.530757','2021-05-04 13:47:14.530757','IMG_6681.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (45,'Leopard Sunflower',5.0,NULL,'Headwrap or single bow','2021-05-04 13:48:24.913649','2021-05-04 13:48:24.913649','IMG_6690-2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (46,'Puzzle Pieces',5.0,NULL,'Puzzle pieces wrap or single cloth bow','2021-05-04 13:49:03.324910','2021-05-04 13:49:03.324910','IMG_6692-2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (47,'Neon Yellow Cloth Bows',8.0,NULL,'Piggies, head wrap, or single bow','2021-05-04 13:49:40.495147','2021-05-04 13:49:40.495147','IMG_6700.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (48,'Layered Kisses Ribbon Bow',8.0,NULL,'Perfect Valentine''s Day Ribbon Bow','2021-05-04 13:50:22.327977','2021-05-04 13:50:22.327977','kisses_purple_layered_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (49,'Leopard Christmas Bow',5.0,NULL,'Leopard Christmas Bow','2021-05-04 13:50:52.086956','2021-05-04 13:50:52.086956','leopard_christmas_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (50,'Leopard Lions Turban Wrap',5.0,NULL,'Support your Durant Lions with this cute Leopard Lions Turban Wrap. Or customize to your school- just message me!','2021-05-04 13:52:05.567723','2021-05-04 13:52:05.567723','lions_leopard_headwrap.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (51,'Leopard Lions Ribbon Bow',5.0,NULL,'Show your school spirit with this cute layered ribbon bow. Add the matching necklace for $4 more.','2021-05-04 13:52:50.384646','2021-05-04 13:52:50.384646','lions_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (52,'Valentine''s Love Layered Bow',8.0,NULL,'Perfect Valentine''s Day Layered Ribbon Bow','2021-05-04 13:53:38.347596','2021-05-04 13:53:38.347596','love_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (53,'Happy New Year',5.0,NULL,'Ring in the new year with this adorable Happy New Year cloth bow','2021-05-04 13:54:19.845678','2021-05-04 13:54:19.845678','new_year_black_gold_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (54,'Ornament Christmas',5.0,NULL,'Ornament Christmas cloth bow','2021-05-04 13:54:48.337061','2021-05-04 13:54:48.337061','ornament_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (55,'Kisses',5.0,NULL,'Kisses ribbon bow','2021-05-04 13:55:26.041846','2021-05-04 13:55:26.041846','pink_kisses_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (56,'Purple Glitter Pumpkin',8.0,NULL,'Make it a piggy set if you want','2021-05-04 13:56:36.308925','2021-05-04 13:56:36.308925','pumpkin_purple_glitter_leather_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (57,'Queen',8.0,NULL,'Queen red and black layered ribbon bow','2021-05-04 13:57:20.692970','2021-05-04 13:57:20.692970','queen_red_black_ribbon_bow1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (58,'Flannel Christmas Piggy Set',8.0,NULL,'Flannel Chritmas Piggy Set','2021-05-04 13:58:27.845353','2021-05-04 13:58:27.845353','red_black_flannel_leather_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (59,'Red Glitter',8.0,NULL,'Red Glitter Piggy Set','2021-05-04 13:59:00.575867','2021-05-04 13:59:00.575867','red_glitter_leather_bows_2.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (60,'Red Sequin',8.0,NULL,'Cute for any occasion','2021-05-04 13:59:38.043560','2021-05-04 13:59:38.043560','red_sequin_cloth_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (61,'Salmon Pink School',5.0,NULL,'School cloth bow in salmon pink color','2021-05-04 14:00:32.750026','2021-05-04 14:00:32.750026','salmon_pink_school_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (62,'Santa Buckle Piggy Set',8.0,NULL,'Santa Buckle Piggy Set','2021-05-04 14:01:05.276286','2021-05-04 14:01:05.276286','santa_christmas_leather_bows.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (63,'Santa Leopard',5.0,NULL,'Add the matching necklace for $4','2021-05-04 14:01:45.858967','2021-05-04 14:01:45.858967','santa_leopard_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (64,'School',5.0,NULL,'Classic school ribbon bow','2021-05-04 14:02:19.652055','2021-05-04 14:02:19.652055','school_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (65,'School Spirit',5.0,NULL,'Show your school spirit with this cute black and gold ribbon bow- or customize anyhow you like!','2021-05-04 14:03:12.080807','2021-05-04 14:03:12.080807','school_spirit_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (66,'Red & Black School Spirit',5.0,NULL,'Another school spirit bow- customize to your liking!','2021-05-04 14:03:51.914672','2021-05-04 14:03:51.914672','school_spirit_ribbon_bow1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (67,'Seuss Fluff',5.0,NULL,'Show your love for Dr. Seuss with this adorable and fluffy ribbon bow','2021-05-04 14:04:42.015038','2021-05-04 14:04:42.015038','seuss_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (68,'Snowman',5.0,NULL,'Snowman ribbon bow','2021-05-04 14:05:10.646050','2021-05-04 14:05:10.646050','snowman_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (69,'Strawberry',5.0,NULL,'Strawberry cloth bow','2021-05-04 14:05:36.748780','2021-05-04 14:05:36.748780','strawberry_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (70,'Mernicorn',8.0,NULL,'Unimaid? Mernicorn? Whatever you like...the magic is all there! Bow or headband style','2021-05-04 14:07:23.470930','2021-05-04 14:07:23.470930','unicorn_mermaid_headband_or_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (71,'Unicorn',5.0,NULL,'Pink unicorn ribbon bow','2021-05-04 14:07:54.960999','2021-05-04 14:07:54.960999','unicorn_ribbon_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (72,'Valentine''s Day XOXO',8.0,NULL,'Adorable Valentine''s Day XOXO Head Wrap','2021-05-04 14:08:46.223923','2021-05-04 14:08:46.223923','valentines_day_xoxo_set.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (73,'Velvet Christmas',5.0,NULL,'Velvety soft Christmas bow','2021-05-04 14:10:41.351826','2021-05-04 14:10:41.351826','velvet_christmas_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (74,'XOXO',5.0,NULL,'XOXO cloth bow','2021-05-04 14:11:11.447424','2021-05-04 14:11:11.447424','xoxo_cloth_bow.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (75,'Kisses XOXO',5.0,NULL,'Kisses XOXO cloth bow','2021-05-04 14:11:47.984149','2021-05-04 14:11:47.984149','xoxo_cloth_headwrap1.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (76,'American Layered Earrings',6.0,NULL,'American layered leather earrings','2021-05-04 14:12:40.904623','2021-05-04 14:12:40.904623','american_layered_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (77,'Floral Striped Teardrop Earrings',6.0,NULL,'Floral Striped Teardrop Earrings','2021-05-04 14:13:21.043210','2021-05-04 14:13:21.043210','floral_striped_teardrop_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (78,'Juniper Pom Pom Earrings',6.0,NULL,'Juniper Pom Pom Earrings','2021-05-04 14:14:13.149114','2021-05-04 14:14:13.149114','green_pompom_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (79,'Leopard Striped Layered Earrings',6.0,NULL,'Leopard Striped Layered Earrings','2021-05-04 14:14:39.250910','2021-05-04 14:14:39.250910','leopard_striped_layered_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (80,'Softball Teardrop Earrings',6.0,NULL,'Softball Teardrop Earrings','2021-05-04 14:15:12.388276','2021-05-04 14:15:12.388276','softball_teardrop_earrings.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (81,'Pearl necklace',4.0,NULL,'Pairs perfect with our black with pearls cloth bow','2021-05-04 14:16:22.444059','2021-05-04 14:16:22.444059','black_white_pearl_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (82,'Christmas Leopard Necklace',4.0,NULL,'pairs perfectly with our leopard santa bow','2021-05-04 14:16:57.628440','2021-05-04 14:16:57.628440','christmas_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (83,'Hocus Pocus Necklace',4.0,NULL,'Pairs perfectly with our hocus pocus cloth bow','2021-05-04 14:17:29.189086','2021-05-04 14:17:29.189086','hocus_pocus_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (84,'Lions Necklace',4.0,NULL,'Pairs perfectly with our Lions ribbon bow','2021-05-04 14:17:56.677998','2021-05-04 14:17:56.677998','lions_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (85,'XOXO Necklace',4.0,NULL,'Pairs perfectly with any of our valentine''s day bows','2021-05-04 14:18:42.911285','2021-05-04 14:18:42.911285','xoxo_necklace.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (86,'Black & Gold Geo',6.0,NULL,'Adorable phone grip','2021-05-04 14:19:25.274439','2021-05-04 14:19:25.274439','black_gold_geo.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (87,'Yellowstone',6.0,NULL,'“We’re with the Yellowstone. Nobody’s gonna mess with us”','2021-05-04 14:21:41.434082','2021-05-04 14:21:41.434082','yellowstone.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (88,'tiktok',6.0,NULL,'TikTok phone grip','2021-05-04 14:22:00.502268','2021-05-04 14:22:00.502268','tiktok.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (89,'Lions',6.0,NULL,'Customize to your own school','2021-05-04 14:22:26.367640','2021-05-04 14:22:26.367640','lions.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (90,'Harry Potter Books',10.0,NULL,'Pairs perfectly with our Harry Potter cloth bows','2021-05-04 14:23:19.719911','2021-05-04 14:23:19.719911','books_baby_tee.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (91,'Bunny Bummies',8.0,NULL,'Aren''t these adorable! Bunny tail is removeable','2021-05-04 14:23:54.266578','2021-05-04 14:23:54.266578','bunny_bummies.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (92,'I''m Extra Guac Too',15.0,NULL,'Is your lil one EXTRA too??','2021-05-04 14:24:57.712959','2021-05-04 14:24:57.712959','extra_guac_print.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (93,'Thelma & Louise',24.0,NULL,'Cutest Thelma and Louise I''ve ever seen!','2021-05-04 14:25:38.634735','2021-05-04 14:25:38.634735','thelma_louise_outfits.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (94,'Yellowstone Outfit',15.0,NULL,'Bummies and crop top- adorable!','2021-05-04 14:26:13.278791','2021-05-04 14:26:13.278791','yellowstone_outfit.jpg',NULL,1);
INSERT INTO "hbc_app_item" VALUES (95,'Did You Dye Bunny Onesie',8.0,NULL,'Customize to your liking','2021-05-04 14:26:54.537513','2021-05-04 14:26:54.537513','grey_did_you_dye_bunny_onesie.png',NULL,1);
INSERT INTO "hbc_app_item" VALUES (96,'Lions Leopard Outfit',15.0,NULL,'Onesie and leopard bummies- customize to your liking','2021-05-04 14:27:36.048512','2021-05-04 14:27:36.048512','lions_leopard_print.jpg',NULL,1);
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
