<?php 


	require_once "mainModel.php";

	/**
	 * 
	 */
	class empresaModelo extends mainModel{

		/* 	Agregar empresa a DB
		*	@param: array de datos, desde controlador
		*  	@return: respuesta del servidor, exito/fallido
		*/
		protected static function agregar_empresa_modelo($datos){
			$sql=mainModel::conectar()->prepare("INSERT INTO empresa(rif,empresaNombre,empresaDireccion,empresaTelefono,empresaCorreo,empresaFotoUrl,empresaMoneda,empresaIva) VALUES(:Rif,:Nombre,:Direccion,:Telefono,:Correo,:FotoUrl,:Moneda,:Iva) ");

			  $sql->bindParam(":Rif",$datos['Rif']);
			  $sql->bindParam(":Nombre",$datos['Nombre']);
			  $sql->bindParam(":Direccion",$datos['Direccion']);
			  $sql->bindParam(":Telefono",$datos['Telefono']);
			  $sql->bindParam(":Correo",$datos['Email']);
			  $sql->bindParam(":FotoUrl",$datos['FotoUrl']);
			  $sql->bindParam(":Moneda",$datos['Moneda']);
			  $sql->bindParam(":Iva",$datos['Iva']);
			  $sql->execute();
			  
			  return $sql;
		}// agregar_empresa_modelo

		protected function datos_empresa_modelo($tipo){
	 		if($tipo=="Unico"){
	 			$query=mainModel::conectar()->prepare("SELECT * FROM empresa");
	 			// $query->bindParam(":Codigo",$);

	 		}elseif($tipo=="Conteo"){
	 			$query=mainModel::conectar()->prepare("SELECT idempresa FROM empresa");

	 		}
	 		$query->execute();
	 		return $query;
 		}

 		/* Editar empresa
		*	@param: $datos:array de datos
		*/
		protected static function actualizar_empresa_modelo($datos){
			$sql=mainModel::conectar()->prepare("UPDATE empresa SET rif=:RIF,empresaNombre=:Nombre,empresaDireccion=:Direccion,empresaTelefono=:Telefono,empresaCorreo=:Correo,empresaFotoUrl=:Foto,empresaMoneda=:Moneda,empresaIva=:Iva WHERE idempresa=:Id");
			
			$sql->bindParam(":RIF",$datos['Rif']);	

			$sql->bindParam(":Nombre",$datos['Nombre']);	
			$sql->bindParam(":Direccion",$datos['Direccion']);
			$sql->bindParam(":Telefono",$datos['Telefono']);
			$sql->bindParam(":Correo",$datos['Email']);
			$sql->bindParam(":Foto",$datos['FotoUrl']);
			$sql->bindParam(":Moneda",$datos['Moneda']);
			$sql->bindParam(":Iva",$datos['Iva']);
			$sql->bindParam(":Id",$datos['Id']);
			$sql->execute();

			return $sql;

		}

	}