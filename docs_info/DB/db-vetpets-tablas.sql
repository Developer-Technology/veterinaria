-- --------------------------------------------------------
-- Host:                         localhost
-- Versión del servidor:         5.7.24 - MySQL Community Server (GPL)
-- SO del servidor:              Win32
-- HeidiSQL Versión:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Volcando estructura para tabla db-vetpets-v.adjuntoshistorial
CREATE TABLE IF NOT EXISTS `adjuntoshistorial` (
  `idAdjunto` int(11) NOT NULL AUTO_INCREMENT,
  `codHistorialM` varchar(50) DEFAULT NULL,
  `adjTipo` varchar(50) DEFAULT NULL,
  `adjFileName` text,
  `adjTitulo` varchar(100) DEFAULT NULL,
  `adjFecha` date DEFAULT NULL,
  PRIMARY KEY (`idAdjunto`),
  KEY `codHistorialM` (`codHistorialM`),
  CONSTRAINT `FK_adjuntoshistm_historialmascota` FOREIGN KEY (`codHistorialM`) REFERENCES `historialmascota` (`codHistorialM`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.adjuntoshistorial: ~0 rows (aproximadamente)
DELETE FROM `adjuntoshistorial`;
/*!40000 ALTER TABLE `adjuntoshistorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `adjuntoshistorial` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.citas
CREATE TABLE IF NOT EXISTS `citas` (
  `idCita` int(11) NOT NULL AUTO_INCREMENT,
  `codCita` varchar(50) DEFAULT NULL,
  `codMascota` varchar(50) DEFAULT NULL,
  `dniCliente` int(11) DEFAULT NULL,
  `citafechaEmitida` date DEFAULT NULL,
  `citaFechaProxima` date DEFAULT NULL,
  `citaHora` varchar(50) DEFAULT NULL,
  `citaMotivo` varchar(100) DEFAULT NULL,
  `citaEstado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idCita`),
  UNIQUE KEY `codCita` (`codCita`),
  KEY `codMascota` (`codMascota`),
  KEY `dniCliente` (`dniCliente`),
  CONSTRAINT `FK_citas_cliente` FOREIGN KEY (`dniCliente`) REFERENCES `cliente` (`clienteDniCedula`),
  CONSTRAINT `FK_citas_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.citas: ~0 rows (aproximadamente)
DELETE FROM `citas`;
/*!40000 ALTER TABLE `citas` DISABLE KEYS */;
/*!40000 ALTER TABLE `citas` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT,
  `clienteDniCedula` int(12) NOT NULL,
  `clienteNombre` varchar(50) DEFAULT NULL,
  `clienteApellido` varchar(50) DEFAULT NULL,
  `clienteGenero` varchar(20) DEFAULT NULL,
  `clienteTelefono` varchar(20) DEFAULT NULL,
  `clienteCorreo` varchar(150) DEFAULT NULL,
  `clienteDomicilio` varchar(150) DEFAULT NULL,
  `clienteFotoUrl` text,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `dniCedula` (`clienteDniCedula`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.cliente: ~0 rows (aproximadamente)
DELETE FROM `cliente`;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.detalleventa
CREATE TABLE IF NOT EXISTS `detalleventa` (
  `idDetalle` int(11) NOT NULL AUTO_INCREMENT,
  `codFactura` int(11) DEFAULT NULL,
  `codProducto` varchar(50) DEFAULT NULL,
  `detalleCantidad` int(11) DEFAULT NULL,
  `precio_venta` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idDetalle`),
  KEY `codProducto` (`codProducto`),
  KEY `codFactura` (`codFactura`),
  CONSTRAINT `FK_detalleVenta_producto` FOREIGN KEY (`codProducto`) REFERENCES `productoservicio` (`codProdservi`),
  CONSTRAINT `FK_detalleventa_venta` FOREIGN KEY (`codFactura`) REFERENCES `venta` (`idVenta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.detalleventa: ~0 rows (aproximadamente)
DELETE FROM `detalleventa`;
/*!40000 ALTER TABLE `detalleventa` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalleventa` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.detalle_temp
CREATE TABLE IF NOT EXISTS `detalle_temp` (
  `correlativo` int(11) NOT NULL AUTO_INCREMENT,
  `token_user` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `codproducto` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_venta` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`correlativo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- Volcando datos para la tabla db-vetpets-v.detalle_temp: ~0 rows (aproximadamente)
DELETE FROM `detalle_temp`;
/*!40000 ALTER TABLE `detalle_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_temp` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.empresa
CREATE TABLE IF NOT EXISTS `empresa` (
  `idempresa` int(20) NOT NULL AUTO_INCREMENT,
  `rif` varchar(50) NOT NULL DEFAULT '',
  `empresaNombre` varchar(100) DEFAULT NULL,
  `empresaDireccion` varchar(200) DEFAULT NULL,
  `empresaTelefono` varchar(20) DEFAULT NULL,
  `empresaCorreo` varchar(100) DEFAULT NULL,
  `empresaFotoUrl` text,
  `empresaMoneda` varchar(10) DEFAULT NULL,
  `empresaIva` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idempresa`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.empresa: ~0 rows (aproximadamente)
DELETE FROM `empresa`;
/*!40000 ALTER TABLE `empresa` DISABLE KEYS */;
/*!40000 ALTER TABLE `empresa` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.especie
CREATE TABLE IF NOT EXISTS `especie` (
  `idEspecie` int(11) NOT NULL AUTO_INCREMENT,
  `espNombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idEspecie`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.especie: ~2 rows (aproximadamente)
DELETE FROM `especie`;
/*!40000 ALTER TABLE `especie` DISABLE KEYS */;
INSERT INTO `especie` (`idEspecie`, `espNombre`) VALUES
	(10, 'Canino'),
	(11, 'Felino');
/*!40000 ALTER TABLE `especie` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.historialmascota
CREATE TABLE IF NOT EXISTS `historialmascota` (
  `idHistorial` int(11) NOT NULL AUTO_INCREMENT,
  `codHistorialM` varchar(50) NOT NULL,
  `histFecha` date NOT NULL,
  `histHora` time NOT NULL,
  `histMotivo` varchar(100) NOT NULL,
  `histSintomas` varchar(350) NOT NULL,
  `histDiagnostico` varchar(350) NOT NULL,
  `histTratamiento` varchar(350) NOT NULL,
  `histCreador` varchar(100) NOT NULL,
  `codMascota` varchar(50) NOT NULL,
  PRIMARY KEY (`idHistorial`),
  UNIQUE KEY `codHistorialM` (`codHistorialM`),
  KEY `codMascota` (`codMascota`),
  CONSTRAINT `FK_historialmascota_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.historialmascota: ~0 rows (aproximadamente)
DELETE FROM `historialmascota`;
/*!40000 ALTER TABLE `historialmascota` DISABLE KEYS */;
/*!40000 ALTER TABLE `historialmascota` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.historialvacuna
CREATE TABLE IF NOT EXISTS `historialvacuna` (
  `idHistoriaVacuna` int(11) NOT NULL AUTO_INCREMENT,
  `idVacuna` int(11) DEFAULT '0',
  `historiavFecha` date DEFAULT NULL,
  `historiavProducto` varchar(150) DEFAULT NULL,
  `historiavObser` varchar(150) DEFAULT NULL,
  `codMascota` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idHistoriaVacuna`),
  KEY `Índice 2` (`idVacuna`),
  KEY `Índice 3` (`codMascota`),
  CONSTRAINT `FK_historialvacuna_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_historialvacuna_vacunas` FOREIGN KEY (`idVacuna`) REFERENCES `vacunas` (`idVacuna`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.historialvacuna: ~0 rows (aproximadamente)
DELETE FROM `historialvacuna`;
/*!40000 ALTER TABLE `historialvacuna` DISABLE KEYS */;
/*!40000 ALTER TABLE `historialvacuna` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.mascota
CREATE TABLE IF NOT EXISTS `mascota` (
  `idmascota` int(11) NOT NULL AUTO_INCREMENT,
  `codMascota` varchar(50) DEFAULT NULL,
  `mascotaNombre` varchar(100) DEFAULT NULL,
  `mascotaFechaN` date DEFAULT NULL,
  `mascotaPeso` varchar(10) DEFAULT NULL,
  `mascotaColor` varchar(100) DEFAULT NULL,
  `idEspecie` int(11) DEFAULT NULL,
  `idRaza` int(11) DEFAULT NULL,
  `mascotaFoto` text,
  `mascotaSexo` varchar(10) DEFAULT NULL,
  `mascotaAdicional` varchar(200) DEFAULT NULL,
  `dniDueno` int(20) DEFAULT NULL,
  PRIMARY KEY (`idmascota`),
  UNIQUE KEY `CodMascota` (`codMascota`),
  KEY `idEspecie` (`idEspecie`),
  KEY `idRaza` (`idRaza`),
  KEY `dniDueno` (`dniDueno`),
  CONSTRAINT `FK_mascota_cliente` FOREIGN KEY (`dniDueno`) REFERENCES `cliente` (`clienteDniCedula`),
  CONSTRAINT `FK_mascota_especie` FOREIGN KEY (`idEspecie`) REFERENCES `especie` (`idEspecie`),
  CONSTRAINT `FK_mascota_raza` FOREIGN KEY (`idRaza`) REFERENCES `raza` (`idRaza`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.mascota: ~0 rows (aproximadamente)
DELETE FROM `mascota`;
/*!40000 ALTER TABLE `mascota` DISABLE KEYS */;
/*!40000 ALTER TABLE `mascota` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.notasmascotas
CREATE TABLE IF NOT EXISTS `notasmascotas` (
  `idNota` int(11) NOT NULL AUTO_INCREMENT,
  `codMascota` varchar(50) DEFAULT NULL,
  `notaDescripcion` varchar(140) DEFAULT NULL,
  `notaFecha` date DEFAULT NULL,
  PRIMARY KEY (`idNota`),
  KEY `codMascota` (`codMascota`),
  CONSTRAINT `FK_notasm_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.notasmascotas: ~0 rows (aproximadamente)
DELETE FROM `notasmascotas`;
/*!40000 ALTER TABLE `notasmascotas` DISABLE KEYS */;
/*!40000 ALTER TABLE `notasmascotas` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.productoservicio
CREATE TABLE IF NOT EXISTS `productoservicio` (
  `idProdservi` int(11) NOT NULL AUTO_INCREMENT,
  `codProdservi` varchar(50) DEFAULT NULL,
  `prodserviNombre` varchar(100) DEFAULT NULL,
  `prodserviTipo` varchar(50) DEFAULT NULL,
  `prodserviPrecio` decimal(11,2) DEFAULT NULL,
  `prodserviStock` int(11) DEFAULT NULL,
  PRIMARY KEY (`idProdservi`),
  UNIQUE KEY `codProducto` (`codProdservi`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.productoservicio: ~0 rows (aproximadamente)
DELETE FROM `productoservicio`;
/*!40000 ALTER TABLE `productoservicio` DISABLE KEYS */;
/*!40000 ALTER TABLE `productoservicio` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.raza
CREATE TABLE IF NOT EXISTS `raza` (
  `idRaza` int(11) NOT NULL AUTO_INCREMENT,
  `razaNombre` varchar(100) DEFAULT NULL,
  `idEspecie` int(12) DEFAULT NULL,
  PRIMARY KEY (`idRaza`),
  KEY `idEspecie` (`idEspecie`),
  CONSTRAINT `FK_raza_especie` FOREIGN KEY (`idEspecie`) REFERENCES `especie` (`idEspecie`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.raza: ~0 rows (aproximadamente)
DELETE FROM `raza`;
/*!40000 ALTER TABLE `raza` DISABLE KEYS */;
/*!40000 ALTER TABLE `raza` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userDni` int(20) DEFAULT NULL,
  `userNombre` varchar(50) DEFAULT NULL,
  `userApellido` varchar(50) DEFAULT NULL,
  `userTelefono` varchar(20) DEFAULT NULL,
  `userDomicilio` varchar(150) DEFAULT NULL,
  `userEmail` varchar(150) DEFAULT NULL,
  `userFoto` text,
  `userUsuario` varchar(50) DEFAULT NULL,
  `userClave` varchar(500) DEFAULT NULL,
  `userEstado` varchar(50) DEFAULT NULL,
  `userPrivilegio` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userDni` (`userDni`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.usuarios: ~1 rows (aproximadamente)
DELETE FROM `usuarios`;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` (`id`, `userDni`, `userNombre`, `userApellido`, `userTelefono`, `userDomicilio`, `userEmail`, `userFoto`, `userUsuario`, `userClave`, `userEstado`, `userPrivilegio`) VALUES
	(1, 0, 'Administrador', 'Principal', '02511111111', 'Venezuela-Lara', 'admin@correo.com', 'adjuntos/user-sistema-foto/0_01_01_2005_052643user.png', 'admin', 'Rm5jTEIzZTVPSHkrQnhrK3VKNDlJZz09', 'Activa', '1');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.vacunas
CREATE TABLE IF NOT EXISTS `vacunas` (
  `idVacuna` int(11) NOT NULL AUTO_INCREMENT,
  `vacunaNombre` varchar(150) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `especieId` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVacuna`),
  KEY `Índice 2` (`especieId`),
  CONSTRAINT `FK_vacunas_especie` FOREIGN KEY (`especieId`) REFERENCES `especie` (`idEspecie`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.vacunas: ~0 rows (aproximadamente)
DELETE FROM `vacunas`;
/*!40000 ALTER TABLE `vacunas` DISABLE KEYS */;
/*!40000 ALTER TABLE `vacunas` ENABLE KEYS */;

-- Volcando estructura para tabla db-vetpets-v.venta
CREATE TABLE IF NOT EXISTS `venta` (
  `idVenta` int(11) NOT NULL AUTO_INCREMENT,
  `dniCliente` int(11) DEFAULT NULL,
  `ventUsuario` int(11) DEFAULT NULL,
  `ventFecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `ventMetodoPago` varchar(50) DEFAULT NULL,
  `ventTotal` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`idVenta`),
  KEY `dniCliente` (`dniCliente`),
  KEY `Índice 3` (`ventUsuario`),
  CONSTRAINT `FK_venta_cliente` FOREIGN KEY (`dniCliente`) REFERENCES `cliente` (`clienteDniCedula`),
  CONSTRAINT `FK_venta_usuarios` FOREIGN KEY (`ventUsuario`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla db-vetpets-v.venta: ~0 rows (aproximadamente)
DELETE FROM `venta`;
/*!40000 ALTER TABLE `venta` DISABLE KEYS */;
/*!40000 ALTER TABLE `venta` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
