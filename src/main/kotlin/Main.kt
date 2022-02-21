import processing.core.PApplet
import java.awt.Color

//fun main() = PApplet.main(Branchwork1::class.java.name)
fun main() = PApplet.main(Branchwork2::class.java.name)

fun Int.rgb() : Int {
    return Color(this).rgb
}
