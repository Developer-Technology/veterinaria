<?php

    require_once "./modelos/vistasModelo.php";
    
    class vistasControlador extends vistasModelo{
    
        /* Obtener de la carpeta vistas el archivo base plantilla.php
        *   @return plantilla.php
        */
        public function obtener_plantilla_controlador(){
         return   require_once "./vistas/plantilla.php";

        }

        /* Obtener vista segun ruta de url o enlaces
        *  @return: $respuesta, vista a mostrar
        */
        public function obtener_vistas_controlador(){
            #views: declarado en .htaccess
            #explode: variable que permite dividir una varible en partes a partir de un limitador /

            if(isset($_GET['views'])){
              $ruta=explode("/", $_GET['views']);
              $vista = $ruta[0];
              // print_r("hola soy controlador vista");
              # divicion asi MVC/views/0/

               // Si está logueado y quiere acceder al login, redirigir al home
                if ($vista == "login" && isset($_SESSION['token_vetp'])) {
                    header("Location: " . SERVERURL . "home/");
                    exit();
                }

              $respuesta=vistasModelo::obtener_vistas_modelo($vista);
              
             }else{
                //variable views no definida
                 $respuesta = "login";
             }
         return  $respuesta;
        }
}