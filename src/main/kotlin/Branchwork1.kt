import hype.*
import hype.extended.layout.HShapeLayout
import processing.core.PApplet
import processing.core.PGraphics
import java.awt.Color


class Branchwork1 : PApplet() {
    private val imageFileName = "branchwork-render.png"
    private val vectorFileName = "cyrcle3-vrender.pdf"
    private val saveImg = false
    private val saveVct = false
    private val scaleFactor = 4

    override fun settings() {
        size(800,800)
        smooth()
        noLoop()
    }
    override fun setup() {
        H.init(this)
        H.background(0xFFFFFF.rgb())
        drawBranches("branch-layout-1.png", 20, 25, 250, false);
        drawBranches("branch-layout-1.png", 100, 15, 250, false);
        //drawBranches("branch-layout-2.png", 200, 40, 250, false);
        drawBranches("branch-layout-3.png", 800, 15, 100, false);
        drawBranches("branch-layout-3.png", 1000, 5, 175, false);
        drawBranches(null, 10000, 2, 80, false);
        drawBranches("branch-layout-3.png", 1000, 50, 150, true);
        val r = HRect(10f, height.toFloat())
        r.fill(0x000000.rgb()).noStroke().loc(width.toFloat()/2f, 500f)
        H.add(r)

        if (saveVct) {
            saveVector();
        }

        if (saveImg) {
            saveHiRes(scaleFactor);
        }
    }

    fun drawBranches(layout: String?, count: Int, size: Int, alpha: Int, fill: Boolean) {
        val branchPool = HDrawablePool(count).autoAddToStage()
            .add(HShape("branchwork1.svg"))
            .add(HShape("branchwork2.svg"))
            .add(HShape("branchwork3.svg"))
            .onCreate { obj ->
                val d = obj as HShape
                d
                    .enableStyle(false)
                    .strokeJoin(ROUND)
                    .strokeCap(ROUND)
                    .strokeWeight(random(1f, 5f))
                    .stroke(0x000000.rgb())
                    .rotate(random(360f))
                    .anchorAt(H.CENTER)
                    .size(size + random(0f, 50f))
                    .alpha(alpha)


                if (fill) {
                    d.fill(0x000000.rgb())
                } else {
                    d.noFill();
                }
                if (layout == null) {
                    d.loc(random(width.toFloat()), random(height.toFloat()));
                }
            }
        if (layout != null) {
            branchPool.layout(HShapeLayout().target(HImage(layout)))
        }
        branchPool.requestAll()
    }

    override fun draw() {
        H.drawStage()
    }
    fun saveVector() {
        val tmp: PGraphics? = beginRecord(PDF, vectorFileName)
        if (tmp == null) {
            H.drawStage()
        } else {
            H.stage().paintAll(tmp, false, 1f) // PGrpahics, uses3D, alpha
        }
        endRecord()
    }
    fun saveHiRes(scaleFactor: Int) {
        val hires = createGraphics(width * scaleFactor, height * scaleFactor, JAVA2D)
        beginRecord(hires)
        hires?.scale(scaleFactor.toFloat())
        if (hires == null) {
            H.drawStage()
        } else {
            H.stage().paintAll(hires, false, 1f) // PGrpahics, uses3D, alpha
        }
        endRecord()
        hires.save("render/$imageFileName")
    }
}

fun Int.rgb() : Int {
    return Color(this).rgb
}

