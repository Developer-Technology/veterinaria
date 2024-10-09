<?php

// print_r($_REQUEST);
// print_r($_REQUEST['cl']);
//exit;

    $peticionAjax=true;

	require_once "../modelos/mainModel.php";
	require_once '../pdf/vendor/autoload.php';
	
	use Dompdf\Dompdf;

	/**
	 * Generar reportes listas en pdf
	 */
	class generarReportsLista extends mainModel
	{

		public function imprimirReport(){

			if(empty($_REQUEST['cl']))
			{
				echo "No es posible generar report";
			}else{
				$tabla = $_REQUEST['cl'];
				$fecha_hoy = mainModel::fecha_castellano(date('d-m-Y'),3);
				
				// datos empresa
				$query_config = mainModel::ejecutar_consulta_simple("SELECT * FROM empresa");
				$result_config = $query_config->rowCount();

				if($result_config > 0){
					$configuracion = $query_config->fetch();
				}else{
					echo "no cargo datos empresa";
				}
				/*------ Cabecera Tablet -------------*/
				$detalles_fecha = "";
				if($tabla=="cliente"){
					$query=mainModel::ejecutar_consulta_simple("SELECT * FROM cliente ORDER BY clienteDniCedula ASC");
					$titulo="Lista de Clientes";
					$cabeceraTable="
								<th>#</th>
		                        <th>Cedula</th>
		                        <th>Nombre Apellido</th>
		                        <th>Genero</th>
		                        <th>Telefono</th>
		                        <th>Correo</th>
		                        <th>Domicilio</th>";

				}elseif($tabla=="mascota"){

					$query=mainModel::ejecutar_consulta_simple("SELECT t1.*,t2.espNombre,t3.razaNombre,t4.clienteNombre,t4.clienteApellido FROM mascota AS t1 INNER JOIN especie AS t2 ON t1.idEspecie=t2.idEspecie INNER JOIN raza AS t3 ON t1.idRaza=t3.idRaza INNER JOIN cliente AS t4 ON t4.clienteDniCedula=t1.dniDueno ORDER BY t1.idmascota ASC");
					
					$titulo="Lista de Mascotas";
					$cabeceraTable="
								<th>#</th>
		                        <th>Codigo</th>
		                        <th>Nombre</th>
		                        <th>Especie</th>
		                        <th>Raza</th>
		                        <th>Fecha N.</th>
		                        <th>Sexo</th>
		                        <th>Peso</th>
		                        <th>Color</th>
		                        <th>Dueño</th>
		                        ";
				}elseif($tabla=="productoservicio"){
					$query=mainModel::ejecutar_consulta_simple("SELECT * FROM productoservicio");
					
					$titulo="Lista de Productos y servicios";
					$cabeceraTable="
								<th>#</th>
		                        <th>Codigo</th>
		                        <th>Descripción</th>
		                        <th>Tipo</th>
		                        <th>Precio de venta</th>
		                        <th>Stock actual</th>
		                        ";
				}elseif($tabla=="venta"){
					$fecha_inicio=$_REQUEST['fi'];
					$fecha_final=$_REQUEST['ff'];

					$query=mainModel::ejecutar_consulta_simple("SELECT t1.*,t2.clienteNombre,t2.clienteApellido,t3.userNombre,t3.userApellido FROM venta AS t1 INNER JOIN cliente AS t2 ON t1.dniCliente=t2.clienteDniCedula INNER JOIN usuarios AS t3 ON t1.ventUsuario = t3.id WHERE (( DATE(ventFecha) BETWEEN '$fecha_inicio' AND '$fecha_final' )) ORDER BY idVenta DESC");

					$titulo="Reporte de venta";
					$detalles_fecha = '<div class="address">Fecha Inicio: '.$fecha_inicio.' </div>
							<div class="address">Fecha Final: '.$fecha_final.' </div>';
					$cabeceraTable="
								<th>#</th>
		                        <th>N. factura</th>
		                        <th>Cliente</th>
		                        <th>Cédula</th>
		                        <th>Fecha</th>
		                        <th>Vendedor</th>
		                        <th>Metodo Pago</th>
		                        <th>Total</th>";
				}
				/*---x--- Cabecera ---------x----*/

				$result=$query->rowCount();
				$contador = 0;
				$tbodyTable="";
				if($result > 0){
					/*-----------Tbody --------------*/
					while ($rows = $query->fetch()){
						$contador = $contador + 1;
						if($tabla=="cliente"){
							$tbodyTable.='
							<tr>
					          <td>'.$contador.'</td>
					          <td>'.$rows['clienteDniCedula'].'</td>
					          <td>'.$rows['clienteNombre'].' '.$rows['clienteApellido'].'</td>
					          <td>'.$rows['clienteGenero'].'</td>
					          <td>'.$rows['clienteTelefono'].'</td>
					          <td>'.$rows['clienteCorreo'].'</td>
			                  <td>'.$rows['clienteDomicilio'].'</td>
					        </tr>
						';
						}elseif($tabla=="mascota"){
							$tbodyTable.='
								<tr>
						          <td>'.$contador.'</td>
						          <td>'.$rows['codMascota'].'</td>
						          <td>'.$rows['mascotaNombre'].'</td>
						          <td>'.$rows['espNombre'].'</td>
						          <td>'.$rows['razaNombre'].'</td>
						          <td>'.$rows['mascotaFechaN'].'</td>
			                      <td>'.$rows['mascotaSexo'].'</td>
			                      <td>'.$rows['mascotaPeso'].' Kg</td>
			                      <td>'.$rows['mascotaColor'].'</td>
			                      <td>'.$rows['clienteNombre'].' '.$rows['clienteApellido'].' '.$rows['dniDueno'].'</td>
						        </tr>
							';
						}elseif($tabla=="productoservicio"){
							$precio_form = number_format($rows['prodserviPrecio'],2,'.',',');
							if($rows['prodserviTipo']=="Servicio"){
								$stock="ES UN SERVICIO";
							}else{
								$stock=$rows['prodserviStock'];
							}
							$tbodyTable.='
								<tr>
									<td>'.$contador.'</td>
			                      	<td>'.$rows['codProdservi'].'</td>
			                      	<td>'.$rows['prodserviNombre'].'</td>
			                      	<td>'.$rows['prodserviTipo'].'</td>
			                      	<td>'.$precio_form.' '.$configuracion['empresaMoneda'].'</td>
			                      	<td>'.$stock.'</td>
			                     </tr>
							';
						}elseif($tabla=="venta"){
							$num_factura = mainModel::generar_numero_factura($rows['idVenta']);
							$total_formt = number_format($rows['ventTotal'],2,'.',',');
							$tbodyTable.='
								<tr>
									<td>'.$contador.'</td>
			                      	<td>'.$num_factura.'</td>
			                      	<td>'.$rows['clienteNombre'].' '.$rows['clienteApellido'].'</td>
			                      	<td>'.$rows['dniCliente'].'</td>
			                      	<td>'.$rows['ventFecha'].'</td>
			                      	<td>'.$rows['userNombre'].' '.$rows['userApellido'].'</td>
			                      	<td>'.$rows['ventMetodoPago'].'</td>
			                      	<td>'.$total_formt.' '.$configuracion['empresaMoneda'].'</td>
			                     </tr>
							';
						}
							
					} // while 
					/*----X---Tbody-------X--*/

					ob_start();
				    include(dirname('__FILE__').'/reportLista.php');
				    $html = ob_get_clean();

					// instantiate and use the dompdf class
					$dompdf = new Dompdf();

					$dompdf->loadHtml($html);
					// (Optional) Setup the paper size and orientation
					// $dompdf->setPaper('letter', 'portrait');
					if($tabla=="mascota"){
						$dompdf->setPaper('A4', 'landscape');
						$x=380;
						$y=560;
					}else{
						$dompdf->setPaper('A4', 'portrait');
						$x=40;
						$y=800;
					}
					
					// Render the HTML as PDF
					$dompdf->render();
					$canvas= $dompdf->get_canvas();
					// paginacion
					$canvas->page_text($x, $y, "Página: {PAGE_NUM} de {PAGE_COUNT}",null,11,array(0,0,0));

					ob_get_clean();
					// Output the generated PDF to Browser
					$dompdf->stream('report_'.$tabla.'_'.date('d-m-Y').'.pdf',array('Attachment'=>0));
					exit;
				}else{
					echo "Sin registros en tabla";
				}
			}
		} // fin imprimirReport


	} // class generarReportsLista fin
	
	$report = new generarReportsLista();
	$report -> imprimirReport();
