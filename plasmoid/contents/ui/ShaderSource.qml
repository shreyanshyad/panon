import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "utils.js" as Utils

/*
 * This module executes a python script to build 
 * the shader sources.
 */

PlasmaCore.DataSource {

    readonly property var cfg:plasmoid.configuration
    engine: 'executable'

    property string image_shader_source:''
    property string buffer_shader_source:''
    property string texture_uri:''
    property string error_message:''

    readonly property string cmd:Utils.chdir_scripts_root()
        + 'python3 -m panon.effect.build_shader_source'
        + ' '+Qt.btoa(JSON.stringify([cfg.visualEffect,cfg.effectArgValues]))

    connectedSources: [cmd]

    onNewData:{
        if(cfg.debugBackend){
            console.log(cmd)
            console.log(data.stderr)
        }
        var obj;
        try{
            obj=JSON.parse(data.stdout);
        }catch(e){
            console.log("JSON parse error")
            console.log("Executed command:")
            console.log(cmd)
            console.log("JSON content:")
            console.log(data.stdout)
            console.log(data.stderr)
            return
        }
        if('error_code' in obj){
            error_message={
                1:i18n("Error: Find undeclared arguments.")
            }[obj.error_code]
            return
        }
        image_shader_source=obj.image_shader
        buffer_shader_source=obj.buffer_shader
        texture_uri=obj.texture
        error_message=''
    }
}
