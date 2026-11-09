package br.com.octo_placar.placar_overlay

import android.os.Bundle
import android.view.InputDevice
import android.view.KeyEvent
import android.view.MotionEvent
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import kotlin.math.abs

class MainActivity : FlutterActivity() {
    // Parte do nome do dispositivo do controle (aparece no getevent: "BLE-M3 Mouse").
    private val filtro = "BLE-M3"
    private val minDeslize = 20f // pixels; ajuste se o log mostrar dx/dy menores
    private var sink: EventChannel.EventSink? = null
    private var x0 = 0f
    private var y0 = 0f

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "octo/controle")
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(args: Any?, events: EventChannel.EventSink?) { sink = events }
                override fun onCancel(args: Any?) { sink = null }
            })
    }

    private fun doControle(nome: String?) = nome?.contains(filtro, ignoreCase = true) == true

    // O controle chega como mouse: clique + arrasto. A direÃ§Ã£o do arrasto identifica o botÃ£o.
    override fun dispatchTouchEvent(ev: MotionEvent): Boolean {
        if (!ev.isFromSource(InputDevice.SOURCE_MOUSE) || !doControle(ev.device?.name)) {
            return super.dispatchTouchEvent(ev)
        }
        when (ev.actionMasked) {
            MotionEvent.ACTION_DOWN -> { x0 = ev.x; y0 = ev.y }
            MotionEvent.ACTION_UP -> {
                val dx = ev.x - x0
                val dy = ev.y - y0
                val dir = when {
                    abs(dx) < minDeslize && abs(dy) < minDeslize -> "toque"
                    abs(dx) > abs(dy) -> if (dx > 0) "direita" else "esquerda"
                    else -> if (dy > 0) "baixo" else "cima"
                }
                sink?.success(mapOf("tipo" to "gesto", "dir" to dir, "dx" to dx.toInt(), "dy" to dy.toInt()))
            }
        }
        return true // nÃ£o deixa o "clique" do controle tocar nos widgets
    }

    // BotÃµes que o controle mande como tecla (Consumer Control: volume, etc.)
    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        if (!doControle(event.device?.name)) return super.dispatchKeyEvent(event)
        if (event.action == KeyEvent.ACTION_DOWN && event.repeatCount == 0) {
            sink?.success(mapOf(
                "tipo" to "tecla",
                "nome" to KeyEvent.keyCodeToString(event.keyCode),
                "codigo" to event.keyCode,
                "acao" to "down"
            ))
        }
        return true
    }
}
