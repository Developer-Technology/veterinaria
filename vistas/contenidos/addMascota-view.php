<div class="titulo-linea mt-2">
  <h2>
    <i class="flaticon-011-dog"></i>
  Registro Mascota</h2>
  <hr class="sidebar-divider">
</div>
<?php
  $Todalarray=count($pagina);
  if($Todalarray==2){
    require_once "./controladores/clienteControlador.php";
    $inst_cliente = new clienteControlador();
    $datos_cliente=$inst_cliente->datos_cliente_controlador("Unico",$pagina[1]);

    if($datos_cliente->rowCount()==1){
      $campos=$datos_cliente->fetch();
        $perfil_cliente='<input type="hidden" name="perfil_id_dni" value="'.$campos['clienteDniCedula'].'">
      ';
    }else{
      $perfil_cliente="";
    }
  }else{
    $perfil_cliente="";
  }
 ?>
<div class="intro add-mascota-form mb-4">
  <!-- agregar desde perfil cliente agregar mascota ajaxsearch js 186-->
  <form  action="<?php  echo SERVERURL; ?>ajax/mascotaAjax.php" data-form="save"  method="POST" class="FormularioAjax" enctype="multipart/form-data">
  <?php echo $perfil_cliente; ?>
    <div class="row">
      <div class="col-lg-8">
        <div class="row">
          <div class="col-lg-12 mb-2">
            <h3 class="sub-titulo-panel">
              <i class="flaticonv-003-appointment"></i>
                Información General</h3>
          </div> 
          <div class="col-md-6">
            <div class="group">
              <input type="text" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{1,40}" name="mascota_nombre_reg" id="mascota_nombre" maxlength="40" required="" />
              <span class="highlight"></span>
              <span class="bar"></span>
              <label>Nombre</label>
            </div>
          </div>
          <div class="col-md-6">
            <div class="input-group date group" id="id_fecha">
                <input type="text" name="mascota_fecha_reg" value="" class="" required="" />
                <span class="highlight"></span>
                <span class="bar"></span>
                <label>Fecha Nacimiento</label>
                <div class="input-group-addon input-group-append">
                    <div class="input-icon">
                        <i class="fas fa-birthday-cake"></i>
                    </div>
                </div>
            </div>
          </div>
          <div class="col-md-6 mb-2">
            <small>Especie</small><br>
            <select class="selectpicker w-100" serverurl="<?php echo SERVERURL; ?>" name="mascota_especie_reg" id="mascota_especie" data-live-search="true">
              <!-- *** dinamico ** -->
                <?php  
                  require_once "./controladores/especieControlador.php";
                  $insEm=new especieControlador();

                  $dataE=$insEm->buscar_especie_controlador("Select");
 
                  while($rowE=$dataE->fetch()){
                    echo '<option value="'.$ins_loginc->encryption($rowE['idEspecie']).'">'.$rowE['espNombre'].'</option>';
                  }
                ?>
              <!-- *** dinamico ** -->
            </select>
          </div>
          <div class="col-md-6 mb-2">
            <small>Raza</small><br>
            <select class="selectpicker w-100" name="mascota_raza_reg" id="mascota_raza" data-live-search="true" data-show-subtext="true">
              <!-- ***dinamico depende de especie -->
               
              <!-- ***dinamico  -->
            </select>
         </div>
          <div class="col-md-6">
            <div class="group">
              <input type="number" step="0.01" min="0" name="mascota_peso_reg" required="" />
              <span class="highlight"></span>
              <span class="bar"></span>
              <label>Peso (Kg)</label>
            </div>
          </div>
          <div class="col-md-6">
            <div class="group">
              <input type="text" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{1,40}" name="mascota_color_reg" required="" />
              <span class="highlight"></span>
              <span class="bar"></span>
              <label>Color</label>
            </div>
          </div>
          <div class="col-md-6 mb-4">
              <div class="d-flex flex-column radio-de">
                <span>Sexo</span>
                <div>
                  <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" id="radio-sexo-hembra" name="mascota_sexo_reg" value="Hembra" class="custom-control-input" checked="">
                    <label class="custom-control-label" for="radio-sexo-hembra">Hembra</label>
                  </div>
                  <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" id="radio-sexo-macho" name="mascota_sexo_reg" value="Macho" class="custom-control-input">
                    <label class="custom-control-label" for="radio-sexo-macho">Macho</label>
                  </div>  
                </div>
              </div>
          </div>
          <!-- DUEÑO -->
          <div class="col-md-6 mb-4" id="mascota-dueno">
            <small>Dueño</small>

            <div class="d-flex flex-row mascota-dueno align-items-center mt-2">
              <img style="width: 55px; height: 55px;" id="imgpreve-cliente-m" class="rounded-circle mr-2" src="<?php  echo SERVERURL;?>vistas/images/general/user-foto.svg" alt="fotocliente">
              <select class="selectpicker w-100"  name="mascota-dueno" id="select-dueno" serverurl="<?php echo SERVERURL; ?>" data-show-subtext="true" data-live-search="true">
                <!-- ***dinamico***(cargar cliente,input key buscar) -->
                
                <!-- *x**dinamico**x* -->
              </select>
            </div>
          </div>
          <div class="col-12">
            <div class="group">
              <textarea type="textarea" name="mascota_infadicional_reg"></textarea>
              <span class="highlight"></span>
              <span class="bar"></span>
              <label>Inf. Adicional</label>
            </div>
          </div>
        </div>
      </div>
      <!-- FOTO PERFIL -->
      <div class="col-lg-4">
        <h3 class="sub-titulo-panel">
          <i class="fas fa-camera"></i>
          Foto de perfil</h3>
          
        <div class="row h-100 text-center justify-content-center align-items-center">
          <div class="col-12 mb-2">
            <div class="img-preve">
                <img src="<?php  echo SERVERURL;?>vistas/images/general/image-preve.svg" id="imgpreve">
            </div>
          </div>
          <div class="col-12">
            <div class="btn_upload">
              <input type="file" id="archivo_foto_subir_mascota" name="mascota_foto_reg">
              Subir Imagen
              <span class="icon-foto-subir">
                <i class="fas fa-camera-retro fa-sm"></i>
              </span>
            </div>
            <div class="error_msg"></div>
          </div>
        </div>
      </div>
      <!-- X-FOTO PERFIL-X -->
      <div class="col-lg-12 text-center mt-5">
        <button type="submit" class="btn btn-primary">Guardar</button>                    
      </div>
    </div>
  </form>
</div>