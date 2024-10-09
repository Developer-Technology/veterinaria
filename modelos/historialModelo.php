<?php 
 

	require_once "mainModel.php";

	class historialModelo extends mainModel{

		/* 	Agregar historia de mascota a DB
		*	@param: array de datos, desde controlador
		*  	@return: respuesta del servidor, exito/fallido
		*/
		protected static function agregar_historia_modelo($datos){
			$sql=mainModel::conectar()->prepare("INSERT INTO historialmascota(codHistorialM,histFecha,histHora,histMotivo,histSintomas,histDiagnostico,histTratamiento,histCreador,codMascota) VALUES(:Cod,:Fecha,:Hora,:Motivo,:Sintomas,:Diagnostico,:Tratamiento,:Creador,:Mascota) ");

			  $sql->bindParam(":Cod",$datos['codHistorial']);
			  $sql->bindParam(":Fecha",$datos['Fecha']);
			  $sql->bindParam(":Hora",$datos['Hora']);
			  $sql->bindParam(":Motivo",$datos['Motivo']);
			  $sql->bindParam(":Sintomas",$datos['Sintomas']);
			  $sql->bindParam(":Diagnostico",$datos['Diagnostico']);
			  $sql->bindParam(":Tratamiento",$datos['Tratamiento']);
			  $sql->bindParam(":Creador",$datos['Creador']);
			  $sql->bindParam(":Mascota",$datos['Mascota']);
			  $sql->execute();
			  
			  return $sql;
		}// agregar_cliente_modelo


		/* eliminar historia
		* @param: cod: de la historia a eliminar
		*/
		protected static function eliminar_historia_modelo($id){
			$sql=mainModel::conectar()->prepare("DELETE FROM historialmascota WHERE codHistorialM=:ID");

			$sql->bindParam(":ID",$id);
			$sql->execute();

			return $sql;
		} // eliminar_historia_modelo

		/* Datos de historias clinicas
		* @param: $tipo:unico, conteno, $cod: codigo de historia
		*/
		protected static function datos_historia_modelo($tipo,$cod){
			if($tipo=="Unico"){
				$sql=mainModel::conectar()->prepare("SELECT * FROM historialmascota WHERE codHistorialM=:COD");
				$sql->bindParam(":COD",$cod);	
			}elseif($tipo=="Conteo"){
				// total de historias
				$sql=mainModel::conectar()->prepare("SELECT idHistorial FROM historialmascota");	
			}
			$sql->execute();
			return $sql;
		}// datos_historia_modelo


		/* 	Editar historial, session info
		*	@param: $datos:array de datos
		*/
		protected static function actualizar_historia_modelo($datos){
			$sql=mainModel::conectar()->prepare("UPDATE historialmascota SET histMotivo=:Motivo,histSintomas=:Sintomas,histDiagnostico=:Diagnostico,histTratamiento=:Tratamiento WHERE codHistorialM=:COD");
			
			$sql->bindParam(":Motivo",$datos['Motivo']);
			$sql->bindParam(":Sintomas",$datos['Sintomas']);
			$sql->bindParam(":Diagnostico",$datos['Diagnostico']);
			$sql->bindParam(":Tratamiento",$datos['Tratamiento']);
			$sql->bindParam(":COD",$datos['codHistorial']);
			$sql->execute();

			return $sql;

		}

		/* 	Agregar archivos adjuntos de historia
		*	@param: array de datos, desde controlador
		*  	@return: respuesta del servidor, exito/fallido
		*/
		protected static function agregar_historia_adjuntos_modelo($datos){
			$sql=mainModel::conectar()->prepare("INSERT INTO adjuntoshistorial(codHistorialM,adjTipo,adjFileName,adjTitulo,adjFecha) VALUES $datos");
			  $sql->execute();
			  
			  return $sql;
		}// agregar_cliente_modelo

		/* eliminar un archivo adjunto
		* @param: id: del archivo. idAdjunto
		*/
		protected static function eliminar_historia_adjuntos_modelo($id){
			$sql=mainModel::conectar()->prepare("DELETE FROM adjuntoshistorial WHERE idAdjunto=:ID");

			$sql->bindParam(":ID",$id);
			$sql->execute();

			return $sql;
		} // eliminar_historia_adjuntos_modelo
		
		/*  Mastrar archivos adjuntos en perfil mascota
		*	@param: cod: de historia de una mascota
		*/
		protected static function datos_perfil_mascota_adjuntos_modelo($cod){
			$sql=mainModel::conectar()->prepare("SELECT * FROM adjuntoshistorial WHERE codHistorialM=:COD");
			$sql->bindParam(":COD",$cod);
			$sql->execute();
			return $sql;
		}


	}