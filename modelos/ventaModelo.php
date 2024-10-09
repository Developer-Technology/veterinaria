<?php 

	require_once "mainModel.php";

	class ventaModelo extends mainModel{

		/* 	Agregar venta a DB
		*	@param: array de datos
		*  	@return: respuesta del servidor, exito/fallido
		*/
		protected static function agregar_venta_modelo($datos){
			$sql=mainModel::conectar()->prepare("CALL procesar_venta(:USER,:DNI,:TOK,:TIP)");

			$sql->bindParam(":USER",$datos['Usuario']);
			$sql->bindParam(":DNI",$datos['DniCliente']);
			$sql->bindParam(":TOK",$datos['Token']);
			$sql->bindParam(":TIP",$datos['Tipo']);
			$sql->execute();

			return $sql;
		}
		/* eliminar venta
		* @param: id: de venta a eliminar
		*/
		protected static function eliminar_venta_modelo($id){
			$sql=mainModel::conectar()->prepare("DELETE FROM venta WHERE idVenta=:ID");

			$sql->bindParam(":ID",$id);
			$sql->execute();

			return $sql;
		} // eliminar_venta_modelo


		/* 	Agregar a tabla temporal, detalle_temp, los productos/Servicios
		*	@param: array de datos
		*  	@return: respuesta del servidor, exito/fallido
		*/
		protected static function agregar_detalleventa_temp_modelo($datos){
			$sql=mainModel::conectar()->prepare("CALL add_detalle_temp(:COD,:CANT,:TOK)");

			$sql->bindParam(":COD",$datos['Codproducto']);
			$sql->bindParam(":CANT",$datos['Cantidad']);
			$sql->bindParam(":TOK",$datos['Token']);
			$sql->execute();

			return $sql;
		}

		/* Eliminar una fila de tabla temporal, 
		*  @param: $id_detalle: id clave primaria de fila, $token: id de usuario logeado
		*/
		protected static function eliminar_detalletemp_procedimiento($id_detalle,$token){
			$sql=mainModel::conectar()->prepare("CALL del_detalle_temp(:ID,:TOK)");

			$sql->bindParam(":ID",$id_detalle);
			$sql->bindParam(":TOK",$token);
			$sql->execute();

			return $sql;
		}

		/* 	Anular detalle temporal 
		*	@param: $token: id de usuario en md5
		*  	@return: respuesta del servidor, exito/fallido
		*/
		protected static function anular_productodetalle_temp_modelo($token){

			$sql=mainModel::conectar()->prepare("DELETE FROM detalle_temp WHERE token_user=:TOKEN");

			$sql->bindParam(":TOKEN",$token);
			$sql->execute();

			return $sql;

		}

	
	}