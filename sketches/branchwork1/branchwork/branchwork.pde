import processing.pdf.*;
import hype.*;
import hype.extended.layout.*;
import hype.extended.colorist.*;


String imageFileName = "branchwork3.png";
String vectorFileName = "*******.pdf";
boolean saveImg = true;
boolean saveVct = false;
int scaleFactor = 4;

void setup() {
    size(800,800);
    H.init(this).background(#FFFFFF);
    smooth();
    
    drawBranches("branch-layout-1.png", 20, 25, 250, false);
    drawBranches("branch-layout-1.png", 100, 15, 250, false);
    //drawBranches("branch-layout-2.png", 200, 40, 250, false);
    drawBranches("branch-layout-3.png", 800, 15, 100, false);
    drawBranches("branch-layout-3.png", 1000, 5, 175, false);
    drawBranches(null, 10000, 2, 80, false);
    drawBranches("branch-layout-3.png", 1000, 50, 150, true);
    HRect r = new HRect(10, height);
    r.fill(#000000).noStroke().loc(width/2,500);
    H.add(r);
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
                        .stroke(#000000)
                        .rotate((int) random(360))
                        .anchorAt(H.CENTER)
                        .size(intParams[0] + (int) random(0, 50))
                        .alpha(intParams[1])
                    ;

                    if (boolParams[0]) {
                        d.fill(#000000);
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