/*
	SQL query templates.
*/



// ======[ TABLES CREATE ]======

char mysql_playertimes_create[] = 
"CREATE TABLE IF NOT EXISTS `playertimes` "...
	"("...
	"`id` INT NOT NULL AUTO_INCREMENT, "...
	"`auth` INT, "...
	"`map` VARCHAR(128), "...
	"`time` FLOAT, "...
	"`jumps` INT, "...
	"`style` TINYINT, "...
	"`date` INT, "...
	"`strafes` INT, "...
	"`sync` FLOAT, "...
	"`points` FLOAT NOT NULL DEFAULT 0, "...
	"`track` TINYINT NOT NULL DEFAULT 0, "...
	"`completions` SMALLINT DEFAULT 1, "...
	"`exact_time_int` INT DEFAULT 0, "...
	"`prestrafe` FLOAT DEFAULT 0, "...
	"PRIMARY KEY (`id`), "...
	"INDEX `map` (`map`, `style`, `track`, `time`), "...
	"INDEX `auth` (`auth`, `date`, `points`), "...
	"INDEX `time` (`time`), "...
	"CONSTRAINT `pt_auth` "...
	"FOREIGN KEY (`auth`) REFERENCES `users` (`auth`) "...
	"ON UPDATE CASCADE ON DELETE CASCADE"...
	") "...
	"ENGINE=INNODB;";

char mysql_wrs_min_create[] = 
"CREATE OR REPLACE VIEW `wrs_min` "...
	"AS SELECT "...
	"MIN(time) time, "...
	"map, "...
	"track, "...
	"style "...
	"FROM `playertimes` "...
	"GROUP BY "...
	"map, "...
	"track, "...
	"style;";

char mysql_wrs_create[] = 
"CREATE OR REPLACE VIEW `wrs` "...
	"AS SELECT "...
	"a.* "...
	"FROM `playertimes` a "...
	"JOIN `wrs_min` b "...
	"ON a.time = b.time "...
	"AND a.map = b.map "...
	"AND a.track = b.track "...
	"AND a.style = b.style;";



// ======[ TABLES INSERT ]======

char mysql_onfinish_insert_new[] = 
"INSERT INTO `playertimes` "...
	"(auth, map, time, jumps, date, style, strafes, sync, points, track, exact_time_int, prestrafe) "...
	"VALUES "...
	"(%d, '%s', %f, %d, %d, %d, %d, %.2f, %f, %d, %d, %.2f);";







// ======[ TABLES UPDATE ]======

char mysql_delete_by_id[] = 
"DELETE FROM `playertimes` "...
	"WHERE id = %d;";

char mysql_delete_all[] = 
"DELETE FROM `playertimes` "...
	"WHERE map = '%s' AND style = %d AND track = %d;";

char mysql_delete_all_by_map[] = 
"DELETE FROM `playertimes` "...
	"WHERE map = '%s';";




// ======[ TABLES QUERY ]======

char mysql_update_maps[] = 
"SELECT map "...
	"FROM `mapzones` "...
	"GROUP BY map;";

char mysql_update_client_cache[] =
"SELECT time, style, track, completions, exact_time_int, prestrafe "...
	"FROM `playertimes` "...
	"WHERE map = '%s' AND auth = %d;";

char mysql_update_wrs_cache[] = 
"SELECT p.id, p.auth, p.style, p.track, p.time, u.name, p.exact_time_int "...
	"FROM `wrs` p "...
	"JOIN `users` u "...
	"ON p.auth = u.auth "...
	"WHERE p.map = '%s';";

char mysql_update_leaderboards_cache[] = 
"SELECT style, track, time, exact_time_int, auth, prestrafe "...
	"FROM `playertimes` "...
	"WHERE map = '%s' "...
	"ORDER BY time ASC, date ASC;";

char mysql_open_delete_menu[] = 
"SELECT p.id, u.name, p.time, p.jumps "...
	"FROM `playertimes` p "...
	"JOIN `users` u "...
	"ON p.auth = u.auth "...
	"WHERE map = '%s' AND style = %d AND track = %d "...
	"ORDER BY time ASC, date ASC "...
	"LIMIT 1000;";

char mysql_get_records_details[] = 
"SELECT u.auth, u.name, p.map, p.time, p.sync, p.perfs, p.jumps, p.strafes, p.id, p.date, "...
			"("...
			"SELECT id "...
			"FROM `playertimes` "...
			"WHERE style = %d AND track = %d AND map = p.map "...
			"ORDER BY time, date ASC "...
			"LIMIT 1"...
			") "...
		"FROM `users` u "...
		"LEFT JOIN `playertimes` p "...
		"ON u.auth = p.auth "...
		"WHERE p.id = %d;";

char mysql_retrieve_wr_menu[] = 
"SELECT style, time "...
	"FROM `wrs` "...
	"WHERE map = '%s' AND track = %d AND style < %d "...
	"ORDER BY style;";

char mysql_select_wr[] = 
"SELECT p.id, u.name, p.time, p.jumps, p.auth "...
	"FROM `playertimes` p "...
	"JOIN `users` u "...
	"ON p.auth = u.auth "...
	"WHERE map = '%s' AND style = %d AND track = %d "...
	"ORDER BY time ASC, date ASC;";

char mysql_select_wr_submenu[] = 
"SELECT u.name, p.time, p.jumps, p.style, u.auth, p.date, p.map, p.strafes, p.sync, p.points, p.track, p.completions "...
	"FROM `playertimes` p "...
	"JOIN `users` u "...
	"ON p.auth = u.auth "...
	"WHERE p.id = %d "...
	"LIMIT 1;";

char mysql_recent_records_menu[] = 
"SELECT a.id, a.map, u.name, a.time, a.style, a.track "...
	"FROM `wrs` a "...
	"JOIN `users` u "...
	"ON a.auth = u.auth "...
	"ORDER BY a.date DESC "...
	"LIMIT 100;";

char mysql_delete_userdata[] = 
"SELECT id, style, track, map "...
	"FROM `wrs` "...
	"WHERE auth = %d;";

char mysql_delete_wr_get_id[] = 
"SELECT id, auth "...
	"FROM `wrs` "...
	"WHERE map = '%s' AND style = %d AND track = %d;";

char mysql_onfinish_update[] = 
"UPDATE `playertimes` "...
	"SET "...
	"time = %f, "...
	"jumps = %d, "...
	"date = %d, "...
	"strafes = %d, "...
	"sync = %.02f, "...
	"points = %f, "...
	"exact_time_int = %d, "...
	"prestrafe = %.02f, "...
	"completions = completions + 1 "...
	"WHERE map = '%s' AND auth = %d AND style = %d AND track = %d;";

char mysql_onfinish_update_completions[] = 
"UPDATE `playertimes` "...
	"SET "...
	"completions = completions + 1 "...
	"WHERE map = '%s' AND auth = %d AND style = %d AND track = %d;";
