<div class="titulo-linea mt-2">
  <h2>
    <i class="flaticon-011-dog"></i>
  Editar Mascota</h2>
  <hr class="sidebar-divider">
</div>
<div class="intro add-mascota-form mb-4">
  <?php
    require_once "./controladores/mascotaControlador.php";
    $inst_mascota = new mascotaControlador();

    $datos_mascota=$inst_mascota->datos_mascota_controlador("Unico",$pagina[1]);

    if($datos_mascota->rowCount()==1){
      $campos=$datos_mascota->fetch();
    
   ?>
  <form  action="<?php  echo SERVERURL; ?>ajax/mascotaAjax.php" data-form="update"  method="POST" class="FormularioAjax" enctype="multipart/form-data">
    <input type="hidden" name="mascota_codigo_up" value="<?php echo $pagina[1] ; ?>">
    <div class="row">
      <div class="col-lg-8">
        <div class="row">
          <div class="col-lg-12 mb-2">
            <h3 class="sub-titulo-panel">
              <i class="flaticonv-003-appointment"></i>
                Información General</h3>
             <span class="float-right"><?php echo $campos['codMascota']; ?></span>   
          </div> 
          <div class="col-md-6">
            <div class="group">
              <input type="text" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{1,40}" name="mascota_nombre_edit" id="mascota_nombre" maxlength="40" value="<?php echo $campos['mascotaNombre'];?>" />
              <span class="highlight"></span>
              <span class="bar"></span>
              <label>Nombre</label>
            </div>
          </div>
          <div class="col-md-6">
            <div class="input-group date group" id="id_fecha">
                <input type="text" name="mascota_fecha_edit" value="<?php echo $campos['mascotaFechaN'];?>" class="" />
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
                    $esp="";
                    if($rowE['idEspecie']==$campos['idEspecie']){
                      $esp='selected=""';
                    }
                    echo '<option value="'.$ins_loginc->encryption($rowE['idEspecie']).'" '.$esp.' >'.$rowE['espNombre'].'</option>';
                  }
                ?>
                <!-- <option selected="true"></option> -->
              <!-- *** dinamico ** -->
            </select>
          </div>
          <div class="col-md-6 mb-2">
            <small>Raza</small><br>
            <input type="hidden" name="id_raza_edit" value="<?php echo $campos['idRaza']; ?>">
            <select class="selectpicker w-100" name="mascota_raza_reg" id="mascota_raza" data-live-search="true" data-show-subtext="true">
              <!-- ***dinamico depende de especie -->
                
              <!-- ***dinamico  -->
            </select>
         </div>
          <div class="col-md-6">
            <div class="group">
              <input type="number" step="0.01" min="0" name="mascota_peso_edit" value="<?php echo $campos['mascotaPeso']; ?>" />
              <span class="highlight"></span>
              <span class="bar"></span>
              <label>Peso (Kg)</label>
            </div>
          </div>
          <div class="col-md-6">
            <div class="group">
              <input type="text" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{1,40}" name="mascota_color_edit" value="<?php echo $campos['mascotaColor']; ?>" />
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
                    <input type="radio" id="radio-sexo-hembra" name="mascota_sexo_edit" value="Hembra" class="custom-control-input" <?php if($campos['mascotaSexo']=="Hembra"){echo 'checked=""';} ?> >
                    <label class="custom-control-label" for="radio-sexo-hembra">Hembra</label>
                  </div>
                  <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" id="radio-sexo-macho" name="mascota_sexo_edit" value="Macho" class="custom-control-input" <?php if($campos['mascotaSexo']=="Macho"){echo 'checked=""';} ?> >
                    <label class="custom-control-label" for="radio-sexo-macho">Macho</label>
                  </div>  
                </div>
              </div>
          </div>
          <!-- DUEÑO -->
          <div class="col-md-6 mb-4" id="mascota-dueno">
            <input type="hidden" name="dueno_id_dni" value="<?php echo $campos['dniDueno']; ?>">
            <small>Dueño</small>
            <div class="d-flex flex-row mascota-dueno align-items-center mt-2">
              <img style="width: 55px; height: 55px;" id="imgpreve-cliente-m" class="rounded-circle mr-2" src="<?php  echo SERVERURL;?>vistas/images/general/user-foto.svg" alt="fotocliente">
              <select class="selectpicker w-100" name="mascota-dueno" id="select-dueno" serverurl="<?php echo SERVERURL; ?>" data-show-subtext="true" data-live-search="true">
                <!-- ***dinamico***(cargar cliente,input key buscar) -->
                 
                <!-- *x**dinamico**x* -->
              </select>
            </div>
          </div>
          <div class="col-12">
            <div class="group">
              <textarea type="textarea" name="mascota_infadicional_edit"><?php echo $campos['mascotaAdicional']; ?></textarea>
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
                <img src="<?php  echo SERVERURL;?><?php echo $campos['mascotaFoto']; ?>" id="imgpreve">
            </div>
          </div>
          <div class="col-12">
            <div class="btn_upload">
              <input type="file" id="archivo_foto_subir_mascota" name="mascota_foto_edit">
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
        <button type="submit" class="btn btn-primary">Actualizar</button>                    
      </div>
    </div>
  </form>
  <?php }else{ ?>
  <div class="alert alert-danger text-center" role="alert">
    <p><i class="fas fa-exclamation-triangle fa-5x"></i></p>
    <h4 class="alert-heading">¡Ocurrió un error inesperado!</h4>
    <p class="mb-0">Lo sentimos, no podemos mostrar la información solicitada debido a un error.</p>
  </div>
<?php } ?>

</div>