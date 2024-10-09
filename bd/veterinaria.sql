-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-06-2022 a las 18:39:11
-- Versión del servidor: 10.4.22-MariaDB
-- Versión de PHP: 7.4.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `veterinaria`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_detalle_temp` (IN `codigo` VARCHAR(50), IN `cantidad` INT, IN `token_user` VARCHAR(50))   BEGIN
		DECLARE precio_actual DECIMAL(11,2);
		
		DECLARE repit_prod INT;
		DECLARE cant_actual INT default 0;
		DECLARE cant_final INT default 0;
		
		SELECT prodserviPrecio INTO precio_actual FROM productoservicio WHERE codProdservi = codigo;
		
		SET repit_prod=(SELECT COUNT(*) FROM detalle_temp tmp WHERE tmp.codproducto=codigo AND tmp.token_user=token_user); 
		
		IF (repit_prod>0) THEN
			SET cant_actual=(SELECT tmp.cantidad FROM detalle_temp tmp WHERE tmp.codproducto=codigo AND tmp.token_user=token_user);
			SET cant_final=cant_actual+cantidad;
			UPDATE detalle_temp tmp SET tmp.cantidad=cant_final WHERE tmp.codproducto=codigo AND tmp.token_user=token_user;
		ELSE
			INSERT INTO detalle_temp(token_user,codproducto,cantidad,precio_venta) VALUES(token_user,codigo,cantidad,precio_actual);
		END IF;
		
		SELECT tmp.correlativo, tmp.codproducto,p.prodserviNombre,tmp.cantidad,tmp.precio_venta FROM detalle_temp tmp
		INNER JOIN productoservicio p
		ON tmp.codproducto = p.codProdservi
		WHERE tmp.token_user = token_user;
		 
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_detalle_temp` (`id_detalle` INT, `token` VARCHAR(50))   BEGIN 
  		DELETE FROM detalle_temp WHERE correlativo = id_detalle;
  		
  		SELECT tmp.correlativo, tmp.codproducto,p.prodserviNombre,tmp.cantidad,tmp.precio_venta FROM detalle_temp tmp
  		INNER JOIN productoservicio p
  		ON tmp.codproducto = p.codProdservi
  		WHERE tmp.token_user = token;
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_venta` (IN `cod_usuario` INT, IN `cod_cliente` INT, IN `token` VARCHAR(50), IN `tipo_pago` VARCHAR(50))   BEGIN
		DECLARE factura INT;
		DECLARE registros INT;
		DECLARE total DECIMAL(10,2);
		
		DECLARE nueva_existencia INT;
		DECLARE existencia_actual INT;
		
		DECLARE tmp_cod_producto varchar(50);
		DECLARE tmp_cant_producto INT;
		DECLARE a INT;
		SET a = 1;
		
		DROP TABLE IF EXISTS tbl_tmp_tokenuser;
		CREATE TEMPORARY TABLE tbl_tmp_tokenuser(
		id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		cod_prod VARCHAR(50),
		cant_prod INT(11));
		
		SET registros = (SELECT COUNT(*) FROM detalle_temp WHERE token_user = token);
		
		IF registros > 0 THEN 
			INSERT INTO tbl_tmp_tokenuser(cod_prod,cant_prod) SELECT codproducto,cantidad FROM detalle_temp WHERE  token_user = token;
			
			INSERT INTO venta(ventUsuario,dniCliente,ventMetodoPago) VALUES (cod_usuario,cod_cliente,tipo_pago);
			SET factura = LAST_INSERT_ID();
			
			INSERT INTO detalleventa(codFactura,codProducto,detalleCantidad,precio_venta) SELECT (factura) AS nofactura,codproducto,cantidad,precio_venta 
			FROM detalle_temp WHERE token_user = token;
			
			while a <= registros DO
				SELECT cod_prod,cant_prod INTO tmp_cod_producto,tmp_cant_producto FROM tbl_tmp_tokenuser WHERE id = a;
				SELECT prodserviStock INTO existencia_actual FROM productoservicio WHERE codProdservi = tmp_cod_producto;
				
				SET nueva_existencia = existencia_actual - tmp_cant_producto;
				UPDATE productoservicio SET prodserviStock = nueva_existencia WHERE codProdservi = tmp_cod_producto AND prodserviTipo = 'Producto';
				
				SET a=a+1; 
				
			END while;
			
			SET total = (SELECT SUM(cantidad*precio_venta) FROM detalle_temp WHERE token_user = token);
			UPDATE venta SET ventTotal = total WHERE idVenta = factura;
			
			DELETE FROM detalle_temp WHERE token_user = token;
			TRUNCATE TABLE tbl_tmp_tokenuser;
			SELECT * FROM venta WHERE idVenta = factura;
			
		ELSE
			SELECT 0;
		END IF;
	END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `adjuntoshistorial`
--

CREATE TABLE `adjuntoshistorial` (
  `idAdjunto` int(11) NOT NULL,
  `codHistorialM` varchar(50) DEFAULT NULL,
  `adjTipo` varchar(50) DEFAULT NULL,
  `adjFileName` text DEFAULT NULL,
  `adjTitulo` varchar(100) DEFAULT NULL,
  `adjFecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
  `idCita` int(11) NOT NULL,
  `codCita` varchar(50) DEFAULT NULL,
  `codMascota` varchar(50) DEFAULT NULL,
  `dniCliente` int(11) DEFAULT NULL,
  `citafechaEmitida` date DEFAULT NULL,
  `citaFechaProxima` date DEFAULT NULL,
  `citaHora` varchar(50) DEFAULT NULL,
  `citaMotivo` varchar(100) DEFAULT NULL,
  `citaEstado` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`idCita`, `codCita`, `codMascota`, `dniCliente`, `citafechaEmitida`, `citaFechaProxima`, `citaHora`, `citaMotivo`, `citaEstado`) VALUES
(2, 'CT-03378-1', 'CM10189-4', 545214785, '2022-05-22', '2022-05-22', '6:30 PM', 'consulta general', 'Pendiente'),
(3, 'CT-98096-2', 'CM05804-5', 878788484, '2022-05-22', '2022-05-22', '8:43 PM', 'dolor de panza', 'Procesada'),
(4, 'CT-77220-3', 'CM03905-6', 656751545, '2022-05-22', '2022-05-22', '8:18 PM', 'consulta general x', 'Procesada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL,
  `clienteDniCedula` int(12) NOT NULL,
  `clienteNombre` varchar(50) DEFAULT NULL,
  `clienteApellido` varchar(50) DEFAULT NULL,
  `clienteGenero` varchar(20) DEFAULT NULL,
  `clienteTelefono` varchar(20) DEFAULT NULL,
  `clienteCorreo` varchar(150) DEFAULT NULL,
  `clienteDomicilio` varchar(150) DEFAULT NULL,
  `clienteFotoUrl` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idCliente`, `clienteDniCedula`, `clienteNombre`, `clienteApellido`, `clienteGenero`, `clienteTelefono`, `clienteCorreo`, `clienteDomicilio`, `clienteFotoUrl`) VALUES
(2, 2147483647, 'Ines', 'Barrera', 'Femenino', '3232121524', 'ines@barrera.com', 'Guatemala', 'adjuntos/clientes-foto/32354512154_22_05_2022_154334Screenshot_2.png'),
(3, 656751545, 'Jorge', 'Barrera', 'Masculino', '5656425124', 'jorge@barrera.com', 'Guatemala', 'vistas/images/avatar_user_cli/avatar_cli_12.svg'),
(4, 878788484, 'Juan', 'Pérez', 'Masculino', '632361165', 'juan@perez.com', 'Guatemala', 'vistas/images/avatar_user_cli/avatar_cli_7.svg'),
(8, 545214785, 'Juana', 'Paz', 'Femenino', '51545451', 'juanita@paz.com', 'Guatemala', 'vistas/images/avatar_user_cli/avatar_cli_3.svg'),
(9, 32384114, 'Josefa', 'Jacinto', 'Femenino', '32655454', 'josefa@jacinto.com', 'Guatemala', 'vistas/images/avatar_user_cli/avatar_cli_6.svg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleventa`
--

CREATE TABLE `detalleventa` (
  `idDetalle` int(11) NOT NULL,
  `codFactura` int(11) DEFAULT NULL,
  `codProducto` varchar(50) DEFAULT NULL,
  `detalleCantidad` int(11) DEFAULT NULL,
  `precio_venta` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `detalleventa`
--

INSERT INTO `detalleventa` (`idDetalle`, `codFactura`, `codProducto`, `detalleCantidad`, `precio_venta`) VALUES
(8, 5, 'CP-98586-1', 2, '5.50'),
(9, 6, 'CP-65052-3', 1, '50.00'),
(10, 7, 'CP-65052-3', 1, '50.00'),
(11, 8, 'CP-98586-1', 3, '5.50'),
(12, 9, 'CP-65052-3', 1, '50.00'),
(13, 10, 'CP-98586-1', 5, '5.50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_temp`
--

CREATE TABLE `detalle_temp` (
  `correlativo` int(11) NOT NULL,
  `token_user` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `codproducto` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_venta` decimal(11,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `detalle_temp`
--

INSERT INTO `detalle_temp` (`correlativo`, `token_user`, `codproducto`, `cantidad`, `precio_venta`) VALUES
(7, 'c4ca4238a0b923820dcc509a6f75849b', 'CP-98586-1', 1, '5.50'),
(8, 'c4ca4238a0b923820dcc509a6f75849b', 'CP-65052-3', 1, '50.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `idempresa` int(20) NOT NULL,
  `rif` varchar(50) NOT NULL DEFAULT '',
  `empresaNombre` varchar(100) DEFAULT NULL,
  `empresaDireccion` varchar(200) DEFAULT NULL,
  `empresaTelefono` varchar(20) DEFAULT NULL,
  `empresaCorreo` varchar(100) DEFAULT NULL,
  `empresaFotoUrl` text DEFAULT NULL,
  `empresaMoneda` varchar(10) DEFAULT NULL,
  `empresaIva` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`idempresa`, `rif`, `empresaNombre`, `empresaDireccion`, `empresaTelefono`, `empresaCorreo`, `empresaFotoUrl`, `empresaMoneda`, `empresaIva`) VALUES
(2, '5454545454', 'Veterinaria LA CABRA CALMANTE', 'Guatemala Guatemala', '+50245118800', 'info@info.com', 'adjuntos/logo-empresa/0_01_01_2005_052643user.png', 'Q', '5.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especie`
--

CREATE TABLE `especie` (
  `idEspecie` int(11) NOT NULL,
  `espNombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `especie`
--

INSERT INTO `especie` (`idEspecie`, `espNombre`) VALUES
(10, 'Canino'),
(11, 'Felino'),
(12, 'Hamster'),
(13, 'Tortugas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historialmascota`
--

CREATE TABLE `historialmascota` (
  `idHistorial` int(11) NOT NULL,
  `codHistorialM` varchar(50) NOT NULL,
  `histFecha` date NOT NULL,
  `histHora` time NOT NULL,
  `histMotivo` varchar(100) NOT NULL,
  `histSintomas` varchar(350) NOT NULL,
  `histDiagnostico` varchar(350) NOT NULL,
  `histTratamiento` varchar(350) NOT NULL,
  `histCreador` varchar(100) NOT NULL,
  `codMascota` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `historialmascota`
--

INSERT INTO `historialmascota` (`idHistorial`, `codHistorialM`, `histFecha`, `histHora`, `histMotivo`, `histSintomas`, `histDiagnostico`, `histTratamiento`, `histCreador`, `codMascota`) VALUES
(3, 'HM-75328-1', '2022-05-22', '09:44:31', 'dolor de panza', 'dolor de panza', 'se le ha dado mucha comida', 'un poquito de leche tibia', 'Administrador Principal', 'CM05804-5'),
(4, 'HM-67303-2', '2022-05-22', '10:18:47', 'consulta general x', 'dolor de pancita', 'mucha comida', 'medicamento para dolor de pancita', 'Administrador Principal', 'CM03905-6');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historialvacuna`
--

CREATE TABLE `historialvacuna` (
  `idHistoriaVacuna` int(11) NOT NULL,
  `idVacuna` int(11) DEFAULT 0,
  `historiavFecha` date DEFAULT NULL,
  `historiavProducto` varchar(150) DEFAULT NULL,
  `historiavObser` varchar(150) DEFAULT NULL,
  `codMascota` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `historialvacuna`
--

INSERT INTO `historialvacuna` (`idHistoriaVacuna`, `idVacuna`, `historiavFecha`, `historiavProducto`, `historiavObser`, `codMascota`) VALUES
(3, 9, '2022-05-22', 'tet', 'test', 'CM05804-5'),
(4, 9, '2022-05-22', '62322', 'vacuna suministrada', 'CM03905-6');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mascota`
--

CREATE TABLE `mascota` (
  `idmascota` int(11) NOT NULL,
  `codMascota` varchar(50) DEFAULT NULL,
  `mascotaNombre` varchar(100) DEFAULT NULL,
  `mascotaFechaN` date DEFAULT NULL,
  `mascotaPeso` varchar(10) DEFAULT NULL,
  `mascotaColor` varchar(100) DEFAULT NULL,
  `idEspecie` int(11) DEFAULT NULL,
  `idRaza` int(11) DEFAULT NULL,
  `mascotaFoto` text DEFAULT NULL,
  `mascotaSexo` varchar(10) DEFAULT NULL,
  `mascotaAdicional` varchar(200) DEFAULT NULL,
  `dniDueno` int(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `mascota`
--

INSERT INTO `mascota` (`idmascota`, `codMascota`, `mascotaNombre`, `mascotaFechaN`, `mascotaPeso`, `mascotaColor`, `idEspecie`, `idRaza`, `mascotaFoto`, `mascotaSexo`, `mascotaAdicional`, `dniDueno`) VALUES
(3, 'CM04366-1', 'Burbuja', '2022-02-04', '12', 'blanco', 10, 5, 'adjuntos/mascotas-foto/2147483647_22_05_2022_154528_1.jpg', 'Hembra', 'test test', 2147483647),
(4, 'CM98122-2', 'Monty', '2022-02-06', '12', 'blanco', 11, 8, 'adjuntos/mascotas-foto/656751545_22_05_2022_181904_descarga.jpg', 'Macho', 'gato', 656751545),
(5, 'CM84787-3', 'Newton', '2020-10-01', '23', 'verde', 13, 9, 'adjuntos/mascotas-foto/2147483647_22_05_2022_182218_Screenshot_1.png', 'Macho', '', 2147483647),
(6, 'CM10189-4', 'Maximiliano', '2020-06-06', '32', 'gris', 10, 5, 'adjuntos/mascotas-foto/545214785_22_05_2022_191910_d420413ef1ab1f2919b6cf291eb0901f.jpg', 'Macho', 'ninguna informacion...', 545214785),
(7, 'CM05804-5', 'Jotch', '2020-10-01', '12', 'barcino', 11, 8, 'adjuntos/mascotas-foto/878788484_22_05_2022_214240_IMG_20220404_133053_811.jpg', 'Macho', 'gato con mucha alegria', 878788484),
(8, 'CM03905-6', 'Rafix', '2022-01-01', '1.5', 'barcino', 11, 8, 'adjuntos/mascotas-foto/656751545_22_05_2022_221542_IMG_20220404_133047_166.jpg', 'Macho', 'gato barcino', 656751545);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notasmascotas`
--

CREATE TABLE `notasmascotas` (
  `idNota` int(11) NOT NULL,
  `codMascota` varchar(50) DEFAULT NULL,
  `notaDescripcion` varchar(140) DEFAULT NULL,
  `notaFecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `notasmascotas`
--

INSERT INTO `notasmascotas` (`idNota`, `codMascota`, `notaDescripcion`, `notaFecha`) VALUES
(1, 'CM05804-5', 'gato muy dormilon', '2022-05-22'),
(2, 'CM03905-6', 'sin problemas', '2022-05-22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productoservicio`
--

CREATE TABLE `productoservicio` (
  `idProdservi` int(11) NOT NULL,
  `codProdservi` varchar(50) DEFAULT NULL,
  `prodserviNombre` varchar(100) DEFAULT NULL,
  `prodserviTipo` varchar(50) DEFAULT NULL,
  `prodserviPrecio` decimal(11,2) DEFAULT NULL,
  `prodserviStock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `productoservicio`
--

INSERT INTO `productoservicio` (`idProdservi`, `codProdservi`, `prodserviNombre`, `prodserviTipo`, `prodserviPrecio`, `prodserviStock`) VALUES
(3, 'CP-98586-1', 'Concentrado para Gato Libra', 'Producto', '5.50', 90),
(4, 'CS-10148-2', 'Grooming', 'Servicio', '150.00', 1),
(5, 'CP-65052-3', 'Collar AntiPulga', 'Producto', '50.00', 47);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `raza`
--

CREATE TABLE `raza` (
  `idRaza` int(11) NOT NULL,
  `razaNombre` varchar(100) DEFAULT NULL,
  `idEspecie` int(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `raza`
--

INSERT INTO `raza` (`idRaza`, `razaNombre`, `idEspecie`) VALUES
(5, 'Pug', 10),
(6, 'Dalmata', 10),
(7, 'Angora', 11),
(8, 'Persa', 11),
(9, 'galápago', 13),
(10, 'Cumberland', 13),
(11, 'enano chino', 12),
(12, 'enano ruso', 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `userDni` int(20) DEFAULT NULL,
  `userNombre` varchar(50) DEFAULT NULL,
  `userApellido` varchar(50) DEFAULT NULL,
  `userTelefono` varchar(20) DEFAULT NULL,
  `userDomicilio` varchar(150) DEFAULT NULL,
  `userEmail` varchar(150) DEFAULT NULL,
  `userFoto` text DEFAULT NULL,
  `userUsuario` varchar(50) DEFAULT NULL,
  `userClave` varchar(500) DEFAULT NULL,
  `userEstado` varchar(50) DEFAULT NULL,
  `userPrivilegio` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `userDni`, `userNombre`, `userApellido`, `userTelefono`, `userDomicilio`, `userEmail`, `userFoto`, `userUsuario`, `userClave`, `userEstado`, `userPrivilegio`) VALUES
(1, 0, 'Administrador', 'Principal', '02511111111', 'Venezuela-Lara', 'admin@correo.com', 'adjuntos/user-sistema-foto/0_01_01_2005_052643user.png', 'admin', 'Rm5jTEIzZTVPSHkrQnhrK3VKNDlJZz09', 'Activa', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacunas`
--

CREATE TABLE `vacunas` (
  `idVacuna` int(11) NOT NULL,
  `vacunaNombre` varchar(150) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `especieId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `vacunas`
--

INSERT INTO `vacunas` (`idVacuna`, `vacunaNombre`, `especieId`) VALUES
(3, 'Labrador', 10),
(4, 'Galgo', 10),
(5, 'Husky', 10),
(6, 'Samoyedo', 10),
(7, 'Dálmata', 10),
(8, 'Pug', 10),
(9, 'vacuna contra los parasitos', 11),
(10, 'vacuna antirrabia', 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `idVenta` int(11) NOT NULL,
  `dniCliente` int(11) DEFAULT NULL,
  `ventUsuario` int(11) DEFAULT NULL,
  `ventFecha` datetime DEFAULT current_timestamp(),
  `ventMetodoPago` varchar(50) DEFAULT NULL,
  `ventTotal` decimal(11,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`idVenta`, `dniCliente`, `ventUsuario`, `ventFecha`, `ventMetodoPago`, `ventTotal`) VALUES
(5, 545214785, 1, '2022-05-22 16:45:19', 'Efectivo', '11.00'),
(6, 656751545, 1, '2022-05-22 16:45:59', 'Efectivo', '50.00'),
(7, 656751545, 1, '2022-05-22 19:46:33', 'Efectivo', '50.00'),
(8, 545214785, 1, '2022-05-22 19:47:15', 'Efectivo', '16.50'),
(9, 656751545, 1, '2022-05-22 20:20:14', 'Efectivo', '50.00'),
(10, 656751545, 1, '2022-05-22 20:20:42', 'Efectivo', '27.50');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `adjuntoshistorial`
--
ALTER TABLE `adjuntoshistorial`
  ADD PRIMARY KEY (`idAdjunto`),
  ADD KEY `codHistorialM` (`codHistorialM`);

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
  ADD PRIMARY KEY (`idCita`),
  ADD UNIQUE KEY `codCita` (`codCita`),
  ADD KEY `codMascota` (`codMascota`),
  ADD KEY `dniCliente` (`dniCliente`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idCliente`),
  ADD UNIQUE KEY `dniCedula` (`clienteDniCedula`);

--
-- Indices de la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  ADD PRIMARY KEY (`idDetalle`),
  ADD KEY `codProducto` (`codProducto`),
  ADD KEY `codFactura` (`codFactura`);

--
-- Indices de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD PRIMARY KEY (`correlativo`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`idempresa`);

--
-- Indices de la tabla `especie`
--
ALTER TABLE `especie`
  ADD PRIMARY KEY (`idEspecie`);

--
-- Indices de la tabla `historialmascota`
--
ALTER TABLE `historialmascota`
  ADD PRIMARY KEY (`idHistorial`),
  ADD UNIQUE KEY `codHistorialM` (`codHistorialM`),
  ADD KEY `codMascota` (`codMascota`);

--
-- Indices de la tabla `historialvacuna`
--
ALTER TABLE `historialvacuna`
  ADD PRIMARY KEY (`idHistoriaVacuna`),
  ADD KEY `Índice 2` (`idVacuna`),
  ADD KEY `Índice 3` (`codMascota`);

--
-- Indices de la tabla `mascota`
--
ALTER TABLE `mascota`
  ADD PRIMARY KEY (`idmascota`),
  ADD UNIQUE KEY `CodMascota` (`codMascota`),
  ADD KEY `idEspecie` (`idEspecie`),
  ADD KEY `idRaza` (`idRaza`),
  ADD KEY `dniDueno` (`dniDueno`);

--
-- Indices de la tabla `notasmascotas`
--
ALTER TABLE `notasmascotas`
  ADD PRIMARY KEY (`idNota`),
  ADD KEY `codMascota` (`codMascota`);

--
-- Indices de la tabla `productoservicio`
--
ALTER TABLE `productoservicio`
  ADD PRIMARY KEY (`idProdservi`),
  ADD UNIQUE KEY `codProducto` (`codProdservi`);

--
-- Indices de la tabla `raza`
--
ALTER TABLE `raza`
  ADD PRIMARY KEY (`idRaza`),
  ADD KEY `idEspecie` (`idEspecie`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `userDni` (`userDni`);

--
-- Indices de la tabla `vacunas`
--
ALTER TABLE `vacunas`
  ADD PRIMARY KEY (`idVacuna`),
  ADD KEY `Índice 2` (`especieId`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`idVenta`),
  ADD KEY `dniCliente` (`dniCliente`),
  ADD KEY `Índice 3` (`ventUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `adjuntoshistorial`
--
ALTER TABLE `adjuntoshistorial`
  MODIFY `idAdjunto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
  MODIFY `idCita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  MODIFY `idDetalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `empresa`
--
ALTER TABLE `empresa`
  MODIFY `idempresa` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `especie`
--
ALTER TABLE `especie`
  MODIFY `idEspecie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `historialmascota`
--
ALTER TABLE `historialmascota`
  MODIFY `idHistorial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `historialvacuna`
--
ALTER TABLE `historialvacuna`
  MODIFY `idHistoriaVacuna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `mascota`
--
ALTER TABLE `mascota`
  MODIFY `idmascota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `notasmascotas`
--
ALTER TABLE `notasmascotas`
  MODIFY `idNota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productoservicio`
--
ALTER TABLE `productoservicio`
  MODIFY `idProdservi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `raza`
--
ALTER TABLE `raza`
  MODIFY `idRaza` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `vacunas`
--
ALTER TABLE `vacunas`
  MODIFY `idVacuna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `idVenta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `adjuntoshistorial`
--
ALTER TABLE `adjuntoshistorial`
  ADD CONSTRAINT `FK_adjuntoshistm_historialmascota` FOREIGN KEY (`codHistorialM`) REFERENCES `historialmascota` (`codHistorialM`) ON DELETE CASCADE;

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `FK_citas_cliente` FOREIGN KEY (`dniCliente`) REFERENCES `cliente` (`clienteDniCedula`),
  ADD CONSTRAINT `FK_citas_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`);

--
-- Filtros para la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  ADD CONSTRAINT `FK_detalleVenta_producto` FOREIGN KEY (`codProducto`) REFERENCES `productoservicio` (`codProdservi`),
  ADD CONSTRAINT `FK_detalleventa_venta` FOREIGN KEY (`codFactura`) REFERENCES `venta` (`idVenta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `historialmascota`
--
ALTER TABLE `historialmascota`
  ADD CONSTRAINT `FK_historialmascota_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`) ON DELETE CASCADE;

--
-- Filtros para la tabla `historialvacuna`
--
ALTER TABLE `historialvacuna`
  ADD CONSTRAINT `FK_historialvacuna_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_historialvacuna_vacunas` FOREIGN KEY (`idVacuna`) REFERENCES `vacunas` (`idVacuna`);

--
-- Filtros para la tabla `mascota`
--
ALTER TABLE `mascota`
  ADD CONSTRAINT `FK_mascota_cliente` FOREIGN KEY (`dniDueno`) REFERENCES `cliente` (`clienteDniCedula`),
  ADD CONSTRAINT `FK_mascota_especie` FOREIGN KEY (`idEspecie`) REFERENCES `especie` (`idEspecie`),
  ADD CONSTRAINT `FK_mascota_raza` FOREIGN KEY (`idRaza`) REFERENCES `raza` (`idRaza`);

--
-- Filtros para la tabla `notasmascotas`
--
ALTER TABLE `notasmascotas`
  ADD CONSTRAINT `FK_notasm_mascota` FOREIGN KEY (`codMascota`) REFERENCES `mascota` (`codMascota`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `raza`
--
ALTER TABLE `raza`
  ADD CONSTRAINT `FK_raza_especie` FOREIGN KEY (`idEspecie`) REFERENCES `especie` (`idEspecie`);

--
-- Filtros para la tabla `vacunas`
--
ALTER TABLE `vacunas`
  ADD CONSTRAINT `FK_vacunas_especie` FOREIGN KEY (`especieId`) REFERENCES `especie` (`idEspecie`);

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `FK_venta_cliente` FOREIGN KEY (`dniCliente`) REFERENCES `cliente` (`clienteDniCedula`),
  ADD CONSTRAINT `FK_venta_usuarios` FOREIGN KEY (`ventUsuario`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
