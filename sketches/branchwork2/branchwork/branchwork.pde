import processing.pdf.*;
import hype.*;
import hype.extended.layout.*;
import hype.extended.colorist.*;


String imageFileName = "branchtexture1.png";
String vectorFileName = "*******.pdf";
boolean saveImg = true;
boolean saveVct = false;
int scaleFactor = 4;

HColorPool colors;

void setup() {
    size(1920,1080);
    H.init(this).background(#220202);
    smooth();
    colors = new HColorPool(#F01010, #E7E7E7, #B01010);
    drawBranches(null, 200, 80, 100, false);
    drawBranches(null, 1000, 45, 120, false);
    //drawBranches("branch-layout-2.png", 200, 40, 250, false);
    drawBranches(null, 1000, 25, 200, false);
    drawBranches(null, 10000, 5, 175, false);
    drawBranches(null, 10000, 2, 225, false);
    drawBranches(null, 5000, 10, 150, false);

    if (saveVct) {
        saveVector();
    }

    if (saveImg) {
        saveHiRes(scaleFactor);
    }

    noLoop();
}

void draw() {
    H.drawStage();
}

void drawBranches(String layout, int count, int size, int alpha, boolean fill) {
    final int[] intParams = new int[2];
    final String[] strParams = new String[1];
    final boolean[] boolParams = new boolean[1];

    intParams[0] = size;
    intParams[1] = alpha;
    strParams[0] = layout;
    boolParams[0] = fill;

    HDrawablePool branchPool = new HDrawablePool(count).autoAddToStage()
        .add(new HShape("branchwork1.svg"))
        .add(new HShape("branchwork2.svg"))
        .add(new HShape("branchwork3.svg"))
        .onCreate(
            new HCallback() {
                public void run(Object obj) {
                    HShape d = (HShape) obj;
                    d 
                        .enableStyle(false)
                        .strokeJoin(ROUND)
                        .strokeCap(ROUND)
                        .strokeWeight((int) random(1, 5))
                        .stroke(colors.getColor())
                        .rotate((int) random(360))
                        .anchorAt(H.CENTER)
                        .size(intParams[0] + (int) random(0, 50))
                        .alpha(intParams[1])
                    ;

                    if (boolParams[0]) {
                        d.fill(colors.getColor());
                    } else {
                        d.noFill();
                    }
                    if (strParams[0] == null) {
                        d.loc((int) random(width), (int) random(height));
                    }
                }
            }
        );

    if (strParams[0] != null) {
        branchPool.layout(
            new HShapeLayout()
                .target(
                    new HImage(strParams[0])
                )
        );
    }
    branchPool.requestAll();

}


void saveVector() {
    PGraphics tmp = null;

    tmp = beginRecord(PDF, vectorFileName);

    if (tmp == null) {
        H.drawStage();
    } else {
        H.stage().paintAll(tmp, false, 1); // PGrpahics, uses3D, alpha
    }
    endRecord();
}

void saveHiRes(int scaleFactor) {
    PGraphics hires = createGraphics(width*scaleFactor, height*scaleFactor, JAVA2D);
    beginRecord(hires);
    hires.scale(scaleFactor);
    if (hires == null) {
        H.drawStage();
    } else {
        H.stage().paintAll(hires, false, 1); // PGrpahics, uses3D, alpha
    }
    endRecord();

    hires.save(imageFileName);
}