CREATE DATABASE  IF NOT EXISTS `art` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `art`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: art
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `material` (
  `materialID` int(11) NOT NULL AUTO_INCREMENT,
  `materialUsed` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`materialID`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material`
--

LOCK TABLES `material` WRITE;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` VALUES (1,'Earthenware, transfer-printed'),(2,'Silver'),(3,'Pewter'),(4,'Steel'),(5,'Etching with stipple and aquatint'),(6,'Pressed purple marble glass'),(7,'Opaque watercolor, ink, silver, and gold on paper'),(8,'Porcelain'),(9,'White cotton thread embroidered on white cotton fabric'),(10,'Earthenware; Redware with slip decoration'),(11,'Woodcut (pages inlaid, modern vellum binding)'),(12,'Embroidered silk on linen'),(13,'Cut blown glass'),(14,'Etching'),(15,'Engraving, woodcut'),(16,'Mottled brown earthenware'),(17,'Iron, copper-silver alloy (<i>shibuichi</i>), gold, silver, copper'),(18,'Boxwood, brass'),(19,'Steel, silver'),(20,'Copper-gold alloy (shakudō), silver'),(21,'Brass, nickel-silver'),(22,'Bronze'),(23,'Engraving, hand-colored'),(24,'Printed book with etched and engraved plates, type rule diagrams, woodcut initials and tailpieces'),(25,'Blown pattern-molded glass, tin'),(26,'Etching; third state of three'),(27,'Parian porcelain'),(28,'Pressed yellow glass'),(29,'Various woods'),(30,'Mahogany, ash, modern upholstery'),(31,'Earthenware'),(32,'Opaque watercolor, silver, and gold on paper'),(33,'Britannia metal'),(34,'Soft ground etching and aquatint'),(35,'Ink, opaque watercolor, and gold on paper'),(36,'Free-blown molded blue glass'),(37,'Ceramic'),(38,'Blown-molded glass'),(39,'Crayon, brush, and spatter lithograph printed in three colors on wove paper; second state of three (frontispiece edition)'),(40,'Pen and black and brown ink, brush and gray wash, red chalk. Incised?'),(41,'Engraving'),(42,'Woodcut'),(43,'Silver, gilt'),(44,'Woven, cotton and wool'),(45,'Pressed glass'),(46,'Etching; eighth state of eight'),(47,'Colored wood engravings'),(48,'Brush and brown and gray ink, black chalk'),(49,'Free-blown glass with applied decoration'),(50,'Graphite'),(51,'Silk on linen'),(52,'Blown overlay clear red, green and colorless glass'),(53,'Steel, silver, niello, nickel'),(54,'Printed book with woodcut illustrations'),(55,'Pressed cranberry and opalescent glass'),(56,'Pressed colorless and opaque cranberry glass'),(57,'Pen and black ink, brush and gray wash, red chalk, lower image squared in black chalk.  Incised.'),(58,'Black chalk, brush and gray and blue wash over black chalk. Paper outside oval washed in rose.'),(59,'Steel, Wedgwood jasperware'),(60,'Graphite, brush and gray wash'),(61,'Earthenware; Redware'),(62,'Paper, ink, polychromy'),(63,'Pine top, figured maple back and sides, rosewood binding, ivory nut, rosewood, mastic, and mother-of-pearl inlaid decoration'),(64,'Etching and engraving'),(65,'Charcoal on laid paper'),(66,'Illustrations: engraving'),(67,'Stained glass'),(68,'Colorless glass, vitreous paint and silver stain'),(69,'Gold, garnet'),(70,'Leather, paper, pencil, ink, colored wash'),(71,'Main support: Ink, opaque watercolor, gold on paper\r\nMargins: Gold on dyed paper'),(72,'Copper-silver alloy (shibuichi), copper, gold, silver'),(73,'Graphite on white paper'),(74,'Pen and black and brown ink, brush and brown wash, over traces of red chalk. Incised.'),(75,'Silk, woven and printed'),(76,'Ivory'),(77,'Linen and cotton with wool embroidered'),(78,'Ink on paper'),(79,'Pen and black ink with gray wash, heightened with white'),(80,'Illustrations: etching'),(81,'Earthenware; Redware with sgraffito decoration'),(82,'Watercolor on wove paper, lined'),(83,'Stipple engraving'),(84,'Free-blown silvered and colorless glass, pewter'),(85,'Blown molded lead glass'),(86,'Pen and black ink, brush and gray wash'),(87,'Wood, various materials'),(88,'Pen and brown ink, gray and some black wash, over graphite'),(89,'Graphite (partially rubbed) on wove paper'),(90,'Iron, lacquer, silk'),(91,'Woodcuts'),(92,'Brush and black ink, white gouache, over a sketch in graphite (?)'),(93,'Crayon lithograph on china paper'),(94,'Favrile glass'),(95,'Silk on linen/wool, embroidered'),(96,'Maple'),(97,'Wool and cotton, woven'),(98,'Mahogany, ash, maple, gilded wood and vert antique with French silk tapestry upholstery'),(99,'Pencil, ink, gray wash on paper'),(100,'Mahogany, birch, white pine'),(101,'Tin-glazed earthenware'),(102,'Main support: Ink, opaque watercolor, gold on paper\r\nMargins: Ink and gold on dyed paper'),(103,'Ink, opaque watercolor, gold, and silver on paper'),(104,'Steel, gold, silver'),(105,'Boxwood, ivory, brass'),(106,'black chalk, heightened with white (recto); black chalk (verso)'),(107,'Pen and point of brush and ink, brush and gray wash, framing line in black ink'),(108,'Lithographs'),(109,'Engraving, etching, woodcut'),(110,'Lithograph'),(111,'Tempera, ink, and shell gold on parchment'),(112,'Pressed cranberry, colorless and opalescent glass'),(113,'Wood (maple), steel,iron, brass'),(114,'Glass, mold-blown'),(115,'Ink, opaque watercolor, silver, and gold on paper'),(116,'Steel, gold, brass, silk, cotton, metallic yarn, paper'),(117,'Wood, nickel-silver'),(118,'Pen and black ink, gray wash, over black chalk underdrawing; framing lines in pen and brown ink'),(119,'Hand-colored woodcut on vellum'),(120,'Ink, wash, paper'),(121,'Wood and various materials'),(122,'Graphite on wove paper'),(123,'Boxwood, ivory'),(124,'Maple, pine'),(125,'Lacy pressed green glass'),(126,'Red and black chalk. Verso of sheet rubbed in black chalk for transfer.'),(127,'Steel, gold, wood (walnut), silver'),(128,'Rosewood, brass, mother-of-pearl, and abalone'),(129,'Etching, aquatint, drypoint'),(130,'Silk and copper thread, woven'),(131,'Etching and burin'),(132,'Brass, nickel-silver, copper'),(133,'Alabaster'),(134,'Copper, gold, silver'),(135,'Lithograph printed in six colors on wove paper; second state of two'),(136,'Drypoint; third state of three'),(137,'Pressed and free-blown opaque white glass'),(138,'Oil on canvasPainting'),(139,'Glass'),(140,'Letterpress text with wood engravings'),(141,'Image: Ink, opaque watercolor, and gold on paper\r\nMargins: Ink and gold on dyed paper'),(142,'Brass, mother-of-pearl, glass shades, and semi-precious stones'),(143,'Watercolor and pen and iron-gall ink on off-white laid paper'),(144,'Brush and point of brush, brown ink and gray chalk-and-ink washes, on laid paper'),(145,'Steel, textile'),(146,'Pewter, wood'),(147,'Pen and ink with watercolor wash on paper'),(148,'Pressed amber glass'),(149,'Pen and brown ink, with color washes, on paper'),(150,'Cherry'),(151,'Free-blown glass'),(152,'Marble (Carrara marble)'),(153,'Bronze, struck'),(154,'Gold, enamel, steel, textile, leather, wood, cotton, velvet'),(155,'Brass'),(156,'Fruitwood, poplar, ebony, satinwood, and oak veneers'),(157,'Pressed blue glass'),(158,'Walnut, spruce, ebony, pearl, tortoiseshell, bone'),(159,'Iron, lacquer, gold'),(160,'Pen and black ink, watercolor, heightened with white, over traces of graphite'),(161,'Mahogany, brass with ash, yellow poplar'),(162,'Cedar'),(163,'Brass; chased'),(164,'Etching; fifth state of five'),(165,'Tempera on canvas'),(166,'Pen and brown ink, gray wash, construction lines in black chalk'),(167,'Pen and black ink, brush and gray and brown ink, black chalk'),(168,'Copper-gold alloy (shakudō), gold, silver'),(169,'Silver plate'),(170,'Charcoal, heightened with white on beige wove paper'),(171,'Etchings'),(172,'Copper-silver alloy (shibuichi), gold, silver'),(173,'Walnut, paper labels, and original silk upholstery'),(174,'Cotton'),(175,'Leaded opalescent glass, brass'),(176,'Black and white chalk on blue paper'),(177,'Binding: Leather, gold, and color; carved, impressed, and gilded\r\nText-block: Ink, opaque watercolor, silver, and gold on paper'),(178,'Spruce, maple, metal, gilding, brass'),(179,'Black, red and white chalk, touches of yellow and pink pastel, on beige paper'),(180,'Pen and brown ink over black chalk.'),(181,'Teak Wood');
/*!40000 ALTER TABLE `material` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-09 13:04:58
