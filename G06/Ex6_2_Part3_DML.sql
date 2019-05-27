/* Guide 6, Exercise 2, Med
 * 30-March-2019
 */

 USE DATABASE DB;

-- Tomando como base o esquema relacional desenvolvido na aula 3 para a base de dados do Sistema de Prescrição Eletrónica de Medicamentos, defina as seguintes queries utilizando expressões de álgebra relacional:

-- a) Lista de pacientes que nunca tiveram uma prescrição;
-- π numUtente, nome, dataNasc, endereco σ numPresc = null (paciente ⟕ prescricao)
SELECT userNumber, name, dateOfBirth, address FROM (C4_MedPrescription.Prescrition AS C1 LEFT JOIN C4_MedPrescription.Patient AS C2 ON C1.patient=C2.userNumber) WHERE number = null

-- b) Número de prescrições por especialidade médica;
-- γ especialidade; numPrescricoes←count(numPresc) (prescricao ⨝ ρ numMedico←numSNS medico)
SELECT speciality, count(number) as numPrescriptions  
FROM C4_MedPrescription.Prescrition AS P JOIN C4_MedPrescription.Doctor AS D ON P.doctor = D.id
GROUP BY speciality

-- c) Número de prescrições processadas por farmácia;
-- γ farmacia; numPrescricoes←count(numPresc) prescricao 	-- ignorar ou não prescrições ainda não utilizadas
SELECT farmacy, count(number) AS numPrescriptions
FROM C4_MedPrescription.Prescrition
GROUP by farmacy

-- d) Para a farmacêutica com registo número 906, lista dos seus fármacos nunca prescritos;
-- π farmaco.nomeFarmaco σ numPresc=null (σ numRegFarm=906 presc_farmaco ⟗ ρ nomeFarmaco←nome σ numRegFarm=906 farmaco )
SELECT name
FROM (C4_MedPrescription.Prescrition AS P FULL OUTER JOIN (SELECT * FROM C4_MedPrescription.Drug WHERE company=906) AS D ON P.farmacy = D.company)
WHERE number=NULL 

-- e) Para cada farmácia, o número de fármacos de cada farmacêutica vendidos;
-- farmaceutica ⨝ ρ numReg←numRegFarm (γ farmacia, numRegFarm; numFarmacos←count(nomeFarmaco) (prescricao ⨝ presc_farmaco))	
SELECT * 
FROM C4_MedPrescription.COMPANY AS C JOIN (SELECT P.farmacy, COUNT(drug) AS numDrugs FROM C4_MedPrescription.Prescrition AS P JOIN C4_MedPrescription.Sold AS S ON P.farmacy=S.farmacy GROUP BY P.farmacy) AS F ON C.id = F.farmacy;

-- f) Pacientes que tiveram prescrições de médicos diferentes.
-- paciente ⨝ π numUtente σ numMedicos > 1 (γ numUtente; numMedicos←count(numMedico) (π numUtente, numMedico prescricao))
SELECT * 
FROM C4_MedPrescription.Patient AS P JOIN (SELECT patient, COUNT(doctor) AS numDoctors FROM C4_MedPrescription.Prescrition GROUP BY patient HAVING COUNT(doctor) > 1) AS N ON P.userNumber = N.patient
