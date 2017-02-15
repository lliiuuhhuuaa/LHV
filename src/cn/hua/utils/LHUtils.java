package cn.hua.utils;

public class LHUtils {
	private static float score;
	public static float calcScore(String grade){
		if(grade!=null){
			String[] grades = grade.split(",");
			if(grades.length==5){
				int t5 = Integer.parseInt(grades[4]);
				int t4 = Integer.parseInt(grades[3]);
				int t3 = Integer.parseInt(grades[2]);
				int t2 = Integer.parseInt(grades[1]);
				int t1 = Integer.parseInt(grades[0]);
				int total = t1+t2+t3+t4+t5;
				if(total==0){
					score=0;
					return score;
				}
				if(total==t5)score=10;
				else if(total==t4)score=8;
				else if(total==t3)score=6;
				else if(total==t2)score=4;
				else if(total==t1)score=2;
				else score=5;
				if(t1==0)score+=1.5;
				else{
					if(t5>t1*10)score+=1.6;
					else if(t5>t1*5)score+=1;
					else if(t5>t1*2)score+=0.8;
					else if(t5>t1)score+=0.6;
					if(t4>t1*10)score+=0.4;
					else if(t4>t1*5)score+=0.3;
					else if(t4>t1*2)score+=0.2;
					else if(t4>t1)score+=0.1;
					if(t3>t1*10)score+=0.2;
					else if(t3>t1*5)score+=0.15;
					else if(t3>t1*2)score+=0.1;
					else if(t3>t1)score+=0.05;
					if(t2>t1*10)score+=0.2;
					else if(t2>t1*5)score+=0.15;
					else if(t2>t1*2)score+=0.1;
					else if(t2>t1)score+=0.05;
				}
				if(t2==0)score+=0.7;
				else{
					if(t5>t2*10)score+=1.4;
					else if(t5>t2*5)score+=0.9;
					else if(t5>t2*2)score+=0.7;
					else if(t5>t2)score+=0.5;
					if(t4>t2*10)score+=0.6;
					else if(t4>t2*5)score+=0.55;
					else if(t4>t2*2)score+=0.35;
					else if(t4>t2)score+=0.15;
					if(t3>t2*10)score+=0.4;
					else if(t3>t2*5)score+=0.3;
					else if(t3>t2*2)score+=0.2;
					else if(t3>t2)score+=0.1;
					if(t1>t2*10)score-=1;
					else if(t1>t2*5)score-=0.7;
					else if(t1>t2*2)score-=0.5;
					else if(t1>t2)score-=0.3;
				}
				if(t3==0&&t5!=0)score+=0.5;
				else{
					if(t5>t3*10)score+=1.2;
					else if(t5>t3*5)score+=0.8;
					else if(t5>t3*2)score+=0.6;
					else if(t5>t3)score+=0.4;
					if(t4>t3*10)score+=0.8;
					else if(t4>t3*5)score+=0.6;
					else if(t4>t3*2)score+=0.4;
					else if(t4>t3)score+=0.2;
					if(t1>t3*10)score-=1.2;
					else if(t1>t3*5)score-=0.8;
					else if(t1>t3*2)score-=0.6;
					else if(t1>t3)score-=0.4;
					if(t2>t3*10)score-=0.8;
					else if(t2>t3*5)score-=0.6;
					else if(t2>t3*2)score-=0.4;
					else if(t2>t3)score-=0.2;
				}
				if(t4==0)score-=0.7;
				else{
					if(t5>t4*10)score+=1;
					else if(t5>t4*5)score+=0.7;
					else if(t5>t4*2)score+=0.5;
					else if(t5>t4)score+=0.3;
					if(t1>t4*10)score-=1.4;
					else if(t1>t4*5)score-=0.9;
					else if(t1>t4*2)score-=0.7;
					else if(t1>t4)score-=0.5;
					if(t2>t4*10)score-=0.6;
					else if(t2>t4*5)score-=0.55;
					else if(t2>t4*2)score-=0.35;
					else if(t2>t4)score-=0.15;
					if(t3>t4*10)score-=0.4;
					else if(t3>t4*5)score-=0.3;
					else if(t3>t4*2)score-=0.2;
					else if(t3>t4)score-=0.1;
				}
				if(t5==0)score-=1.5;
				else{
					if(t1>t5*10)score-=1.6;
					else if(t1>t5*5)score-=1;
					else if(t1>t5*2)score-=0.8;
					else if(t1>t5)score-=0.6;
					if(t2>t5*10)score-=0.4;
					else if(t2>t5*5)score-=0.3;
					else if(t2>t5*2)score-=0.2;
					else if(t2>t5)score-=0.1;
					if(t3>t5*10)score-=0.2;
					else if(t3>t5*5)score-=0.15;
					else if(t3>t5*2)score-=0.1;
					else if(t3>t5)score-=0.05;
					if(t4>t5*10)score-=0.2;
					else if(t4>t5*5)score-=0.15;
					else if(t4>t5*2)score-=0.1;
					else if(t4>t5)score-=0.5;
				}
				if(score<0)score=0;
				if(score>10)score=10;
				if(score>=10){
					if(t1==0)score-=1.2;
					else if(t2==0)score--;
					else if(t3==0)score-=0.8;
					else if(t4==0)score-=0.6;
				}else if(score<=0){
					if(t5==0)score+=1.2;
					else if(t4==0)score++;
					else if(t3==0)score+=0.8;
					else if(t2==0)score+=0.6;
				}
				score= (float)(Math.round(score*10))/10;
			}
		}
		return score;
	}
}
