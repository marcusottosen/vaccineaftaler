package dk.dtu.f21_02327;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Denne klasse repræsenterer en vaccinationsaftale i den fil der modtages fra sundhedsmyndighederne dagligt.
 * 
 * Klassen er en del af projektopgaven på Kursus 02327 F21
 * 
 * @author Thorbjørn Konstantinovitz  
 *
 */
public class VaccinationsAftale {
	private final long cprnr;
	private final String navn;

	private final Date aftaltTidspunkt;
	private final String vaccineType;
	private final String lokation;

	public VaccinationsAftale(long cprnr, String navn, Date aftaltTidspunkt, String vaccineType, String lokation) {
		this.cprnr = cprnr;
		this.navn = navn;
		this.aftaltTidspunkt = aftaltTidspunkt;
		this.vaccineType = vaccineType;
		this.lokation = lokation;

		java.sql.Date sqlDate = new java.sql.Date(aftaltTidspunkt.getTime());
		java.sql.Time sqlTime = new java.sql.Time(aftaltTidspunkt.getTime());
		Importdata Importer = new Importdata();
		try {
			Importer.Importdata(cprnr, navn, sqlDate, sqlTime, vaccineType, lokation);
		} catch (SQLException throwables) {
			throwables.printStackTrace();
		}

	}

	public long getCprnr() {
		return cprnr;
	}

	public String getNavn() {
		return navn;
	}

	public Date getAftaltTidspunkt() {
		return aftaltTidspunkt;
	}

	public String getVaccineType() {
		return vaccineType;
	}

	public String getLokation() {
		return lokation;
	}

	@Override
	public String toString() {
		final String D = ";";
		final SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyyMMdd" +D +"HHmm");

		return getCprnr() + D + getNavn() + D + dateFormatter.format(getAftaltTidspunkt()) + D + getLokation() + D + getVaccineType();
	}
}
