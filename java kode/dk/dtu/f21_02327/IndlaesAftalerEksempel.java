package dk.dtu.f21_02327;

import java.io.IOException;
import java.util.List;

public class IndlaesAftalerEksempel {

	public static void main(String[] args) {
		IndlaesVaccinationsAftaler laeser = new IndlaesVaccinationsAftaler();
		try {
			List<VaccinationsAftale> aftaler = laeser.indlaesAftaler("vaccinationsaftaler.csv");
			for(VaccinationsAftale aftale : aftaler) {
				System.out.println(aftale);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}