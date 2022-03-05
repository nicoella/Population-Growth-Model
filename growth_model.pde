import java.io.*;
import java.util.*;
import java.text.*;

TextBox k = new TextBox(660, 103);
TextBox P0 = new TextBox(660, 128);
TextBox K = new TextBox(660, 153);
PFont f1; //jua
PFont f2; //nunam gothic
PFont f3; //nunam gothic bold
double kv = 0;
long P0v = 0;
long Kv = 0;
boolean anim = false;
double t = 0;
ArrayList<Coord> nat = new ArrayList<Coord>();
ArrayList<Coord> log = new ArrayList<Coord>();
ArrayList<Pop> natmod = new ArrayList<Pop>();
ArrayList<Pop> logmod = new ArrayList<Pop>();
double time = 0;

void setup() {
    size(1200, 600);
    stroke(0, 0, 0, 0);
    textAlign(CENTER);
    f1 = createFont("fonts/Jua-Regular.ttf", 32);
    f2 = createFont("fonts/NanumGothic-Regular.ttf", 32);
    f3 = createFont("fonts/NanumGothic-Bold.ttf", 32);
}

void draw() {
    model();
}

void mouseReleased() {
    if (mouseX >= k.x && mouseX <= k.x + 170 && mouseY >= k.y && mouseY <= k.y + 23) {
        k.on = true;
        P0.on = false;
        K.on = false;
    } else if (mouseX >= P0.x && mouseX <= P0.x + 170 && mouseY >= P0.y && mouseY <= P0.y + 23) {
        k.on = false;
        P0.on = true;
        K.on = false;
    } else if (mouseX >= K.x && mouseX <= K.x + 170 && mouseY >= K.y && mouseY <= K.y + 23) {
        k.on = false;
        P0.on = false;
        K.on = true;
    } else {
        k.on = false;
        P0.on = false;
        K.on = false;
    }
    if (mouseX >= 900 && mouseX <= 1050 && mouseY >= 103 && mouseY <= 166) {
        try { 
            kv = Double.parseDouble(k.s);
        } 
        catch (Exception e) {
            kv = 0;
        }
        try { 
            P0v = Long.parseLong(P0.s);
        } 
        catch (Exception e) {
            P0v = 0;
        }
        try { 
            Kv = Long.parseLong(K.s);
        } 
        catch (Exception e) {
            Kv = 0;
        }
        anim = false;
        nat = new ArrayList<Coord>();
        log = new ArrayList<Coord>();
        natmod = new ArrayList<Pop>();
        logmod = new ArrayList<Pop>();
        t = 0;
    } else if (mouseX >= 1070 && mouseX <= 1170 && mouseY >= 103 && mouseY <= 132) {
        anim = true;
        time = System.nanoTime();
    } else if (mouseX >= 1070 && mouseX <= 1170 && mouseY >= 137 && mouseY <= 166) {
        anim = false;
    }
}

void keyPressed() {
    if (k.on) {
        if ((key >= '0' && key <= '9' || (key=='.' && k.s.length()>0 && !k.s.contains("."))) && k.s.length() <= 9) {
            k.s += key;
        } else if (keyCode == BACKSPACE && k.s.length() > 0) {
            k.s = k.s.substring(0, k.s.length()-1);
        }
    } else if (P0.on) {
        if ((key >= '0' && key <= '9') && P0.s.length() <= 9) {
            P0.s += key;
        } else if (keyCode == BACKSPACE && P0.s.length() > 0) {
            P0.s = P0.s.substring(0, P0.s.length()-1);
        }
    } else if (K.on) {
        if ((key >= '0' && key <= '9') && K.s.length() <= 9) {
            K.s += key;
        } else if (keyCode == BACKSPACE && K.s.length() > 0) {
            K.s = K.s.substring(0, K.s.length()-1);
        }
    }
} 

void model() {
    background(255, 255, 255);

    //separator lines
    fill(206, 223, 235);
    rectMode(CENTER);
    rect(600, 300, 4, 600);
    rectMode(CENTER);
    rect(900, 200, 600, 4);

    //title
    fill( 206, 223, 235);
    rectMode(CORNER);
    rect(0, 0, 1200, 50);
    rectMode(CENTER);
    fill(62, 68, 88);
    textAlign(CENTER);
    textFont(f1, 25);
    text("Natural VS. Logistic Growth Model", 600, 35);

    //labels
    fill(191, 88, 87);
    textAlign(LEFT);
    textFont(f1, 25);
    text("MODEL", 20, 85);
    text("INPUT", 622, 85);
    text("OUTPUT", 622, 237);

    //model
    fill(62, 68, 88);
    textFont(f1, 17);
    textAlign(LEFT);
    text("Natural", 20, 120);
    text("Logistic", 20, 350);
    fill(206, 223, 235);
    rectMode(CORNER);
    for (int x=0; x<600; x+= 30) {
        rect(x, 320, 25, 3);
    }
    double fac = 1;
    if (Kv>5000) {
        fac = Kv/5000.0;
    }
    textFont(f2, 14);
    fill(191, 88, 87);
    text("1 dot = "+fac+" units", 20, 140);
    text("1 dot = "+fac+" units", 20, 370);
    text("# of dots = "+natmod.size(), 20, 160);
    text("# of dots = "+logmod.size(), 20, 390);

    //natural 
    
    if (nat.size()>0) {
        Coord b = nat.get(nat.size()-1);
        double diff = (b.pt/fac - natmod.size());
        if (calcnat(t)>Kv) diff = Math.ceil(Kv/fac - natmod.size());
        if (natmod.size()==0) {
            double r = Math.sqrt(10*10*b.pt/(Kv));
            for (int i=1; i<=diff; i++) {
                double x = 400+Math.random()*(r*2)- r;
                double y = 180+Math.random()*(r*2) - r;
                while (Math.sqrt((400-x)*(400-x)+(180-y)*(180-y))>r) {
                    x = 400+Math.random()*(r*2)- r;
                    y = 180+Math.random()*(r*2) - r;
                }
                natmod.add(new Pop(x, y, 1));
            }
        } else {
            for (int i=1; i<=diff; i++) {
                Pop prev = natmod.get((int)(Math.random()*natmod.size()));
                while(prev.x <= 50 || prev.x >= 550 || prev.y <= 100 || prev.y >= 270) {
                    prev = natmod.get((int)(Math.random()*natmod.size()));
                }
                double ang = (Math.random()*360);
                double newx = Math.cos(ang)*(Math.random()*(20)+5)+prev.x;
                double newy = Math.sin(ang)*(Math.random()*(20)+5)+prev.y;
                natmod.add(new Pop(newx, newy, 1));
            }
        }
    }
    for (Pop p : natmod) {
        p.display();
    }
    
    //logistic
    if (log.size()>0 && calclog(t)<=Kv) {
        Coord b = log.get(log.size()-1);
        double diff = (b.pt/fac - logmod.size());
        if (calclog(t)>Kv) diff = Math.ceil(Kv/fac - logmod.size());
        if(logmod.size()==0) {
            double r = Math.sqrt(10*10*b.pt/(Kv));
            for (int i=1; i<=diff; i++) {
                double x = 400+Math.random()*(r*2)- r;
                double y = 450+Math.random()*(r*2) - r;
                while (Math.sqrt((400-x)*(400-x)+(450-y)*(450-y))>r) {
                    x = 400+Math.random()*(r*2)- r;
                    y = 450+Math.random()*(r*2) - r;
                }
                logmod.add(new Pop(x, y, 2));
            }
        } else {
            for (int i=1; i<=diff; i++) {
                Pop prev = logmod.get((int)(Math.random()*logmod.size()));
                while(prev.x <= 50 || prev.x >= 550 || prev.y <= 370 || prev.y >= 550) {
                    prev = logmod.get((int)(Math.random()*logmod.size()));
                }
                double ang = (Math.random()*360);
                double newx = Math.cos(ang)*(Math.random()*(20)+5)+prev.x;
                double newy = Math.sin(ang)*(Math.random()*(20)+5)+prev.y;
                //check outside boundary
                logmod.add(new Pop(newx, newy, 1));
            }
        }
    }


    for (Pop p : logmod) {
        p.display();
    }

    //input
    //input input
    fill(245, 126, 110);
    textFont(f3, 17);
    textAlign(LEFT);
    text("k: ", 622, 120);
    k.display();
    fill(245, 126, 110);
    textFont(f3, 17);
    textAlign(LEFT);
    text("P0: ", 622, 145);
    P0.display();
    fill(245, 126, 110);
    textFont(f3, 17);
    textAlign(LEFT);
    text("K: ", 622, 170);
    K.display();

    //input buttons
    //button 1
    fill(206, 223, 235);
    rectMode(CORNER);
    rect(900, 103, 150, 63, 20);
    fill(62, 68, 88);
    textAlign(CENTER);
    text("Save Numbers", 975, 130);
    text("& Reset", 975, 150);
    //button 2
    fill(206, 223, 235);
    rectMode(CORNER);
    rect(1070, 103, 100, 29, 20);
    fill(62, 68, 88);
    textAlign(CENTER);
    text("Start", 1120, 123);
    //button 3
    fill(206, 223, 235);
    rectMode(CORNER);
    rect(1070, 137, 100, 29, 20);
    fill(62, 68, 88);
    textAlign(CENTER);
    text("Stop", 1120, 157);

    //output
    //graph
    fill(62, 68, 88);
    textFont(f1, 17);
    textAlign(LEFT);
    text("Population V.S. Time Graph", 622, 272);
    fill(62, 68, 88);
    rect(642, 300, 2, 250);
    rect(642, 550, 290, 2);
    //labels
    pushMatrix();
    translate(622, 425);
    rotate(1.5*PI);
    textFont(f2, 14);
    text("Population [P(t)]", -60, 10);
    popMatrix();
    textAlign(CENTER);
    text("Time [t]", 796, 570);
    //coords
    //hover display
    double r = Math.log(((double)Kv/(Kv-1)-1)*((double)P0v/(Kv-P0v)))/(-kv);
    double i = r / 80;
    if (nat.size()>0 && mouseX>=644 && mouseX<=644+290 && mouseY>=550-250 && mouseY<=550) {
        int pos = (int)((mouseX-644)/3.625);
        fill(191, 88, 87);
        rectMode(CORNER);
        if (pos<=t/i) {
            rect(pos*3.625-1+644, 300, 2, 250);
            double ti = pos*i;
            textAlign(RIGHT);
            textFont(f2, 12);
            fill(191, 88, 87);
            text("t = "+ti, 932, 510);
            if (calcnat(ti)<=Kv) text("Natural = "+roundn(calcnat(ti)), 932, 525);
            else text("Natural = "+roundn(Kv), 932, 525);
            text("Logistic = "+roundn(calclog(ti)), 932, 540);
        }
    }
    if (anim) {
        if (t < r && System.nanoTime() - time >= 300000000) {
            time = System.nanoTime();
            if (calcnat(t)<=Kv) nat.add(new Coord(t, Kv, r, 1));
            log.add(new Coord(t, Kv, r, 2));
            t += i;
        }
    }
    for (Coord c : nat) {
        c.display();
    }
    for (Coord c : log) {
        c.display();
    }

    //statistics
    fill(62, 68, 88);
    textFont(f1, 17);
    textAlign(LEFT);
    text("Statistics", 960, 272);

    textAlign(LEFT);
    fill(62, 68, 88);
    textFont(f3, 14);
    text("k: ", 960, 300);
    fill(191, 88, 87);
    textFont(f2, 14);
    text(roundn(kv)+"", 980, 300);

    textFont(f3, 14);
    fill(62, 68, 88);
    text("P0: ", 960, 330);
    fill(191, 88, 87);
    textFont(f2, 14);
    text(roundn(P0v)+"", 990, 330);

    textFont(f3, 14);
    fill(62, 68, 88);
    text("K: ", 960, 360);
    fill(191, 88, 87);
    textFont(f2, 14);
    text(roundn(Kv)+"", 980, 360);

    textFont(f3, 14);
    fill(62, 68, 88);
    text("t: ", 960, 390);
    fill(191, 88, 87);
    textFont(f2, 14);
    text(roundn(t)+"", 980, 390);

    textFont(f3, 14);
    fill(62, 68, 88);
    text("Natural P(t):", 960, 420);
    fill(191, 88, 87);
    textFont(f2, 14);
    double val = calcnat(t);
    if (val>Kv) val = Kv;
    text(roundn(val)+"", 1050, 420);

    textFont(f3, 14);
    fill(62, 68, 88);
    text("Logistic P(t):", 960, 450);
    fill(191, 88, 87);
    textFont(f2, 14);
    text(roundn(calclog(t))+"", 1060, 450);

    textFont(f3, 14);
    fill(62, 68, 88);
    String str = "Natural P(t) = "+roundn(P0v)+" * e^("+roundn(kv)+"*"+"t) ";
    int y = 480;
    String cur = "";
    while (str.length() > 0) {
        if (cur.length() + str.indexOf(" ") <= 30) {
            cur += str.substring(0, str.indexOf(" ")+1);   
            str = str.substring(str.indexOf(" ")+1);
        } else {
            text(cur, 960, y);
            y += 20;
            cur = "";
        }
    }
    text(cur, 960, y);
    y += 20;
    str = "Logistic P(t) = "+roundn(Kv)+" / [(1 + ("+roundn(Kv)+" - "+roundn(P0v)+") / "+roundn(P0v)+") * (e^(-"+roundn(kv)+"t)] ";
    ;
    cur = "";
    while (str.length() > 0) {
        if (cur.length() + str.indexOf(" ") <= 30) {
            cur += str.substring(0, str.indexOf(" ")+1);   
            str = str.substring(str.indexOf(" ")+1);
        } else {
            text(cur, 960, y);
            y += 20;
            cur = "";
        }
    }
    text(cur, 960, y);
}

String roundn(double v) {
    DecimalFormat f = new DecimalFormat("0.000");
    return f.format(v);
}

//calculation functions
double calcnat(double t) {
    try {
        return P0v*Math.pow(Math.exp(1), kv*t);
    } 
    catch (Exception e) { 
        return -1;
    }
}

double calclog(double t) {
    try {
        return Kv/(1 + ((Kv - P0v)/P0v)*Math.pow(Math.exp(1), -kv*t));
    } 
    catch (Exception e) { 
        return -1;
    }
}

class TextBox {
    int x, y;
    String s = "";
    boolean on = false;

    TextBox(int x, int y) {
        this.x = x;
        this.y = y;
    }

    void display() {
        fill(254, 223, 168);
        rectMode(CORNER);
        rect(x, y, 170, 23, 20);
        fill(191, 88, 87);
        textAlign(LEFT);
        if (on && s.length() <= 12) {
            text(s+"_", x + 13, y + 17);
        } else {
            text(s, x + 13, y + 17);
        }
    }
}

class Coord {
    double t, pt, hei, wid;
    int type;
    Coord(double t, double hei, double wid, int type) {
        this.t = t;
        this.hei = hei;
        this.wid = wid;
        if (type==1) this.pt = calcnat(t);
        else this.pt = calclog(t);
        this.type = type;
    }

    void display() {
        ellipseMode(CENTER);
        if (type==1) fill(276, 100, 100);
        else fill(132, 100, 100);
        ellipse(644 + (float)(t/wid)*(290), 550 - (float)(pt/hei)*(250), 3f, 3f);
    }
}

class Pop {
    double x, y;
    int type;
    Pop(double x, double y, int type) {
        this.x = x;
        this.y = y;
        this.type = type;
    }

    void display() {
        ellipseMode(CENTER);
        if (type==1) fill(276, 100, 100, 60);
        else fill(132, 100, 100, 60);
        ellipse((float)x, (float)y, 5, 5);
    }
}
