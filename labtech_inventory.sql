SELECT computers.Name, computers.username, computers.os, computers.LastContact, computers.BiosName, computers.Biosver, computers.BiosMFG,
inv_memoryslots.RAM, inv_videocard.VideoProcessor, inv_processor.Name, drives.SSD
FROM computers
INNER JOIN inv_processor ON computers.ComputerID = inv_processor.ComputerID
INNER JOIN (
	SELECT computerID, VideoProcessor, AdapterDAC
	FROM inv_videocard
	GROUP BY computerID,
		CASE 
			WHEN AdapterDAC = "Integrated RAMDAC" THEN VideoProcessor
			ELSE VideoProcessor
		END
)inv_videocard ON computers.ComputerID = inv_videocard.ComputerID
INNER JOIN (
	SELECT computerID, SUM(inv_memoryslots.Size) AS RAM
	FROM inv_memoryslots
	GROUP BY ComputerID
)inv_memoryslots ON computers.ComputerID = inv_memoryslots.ComputerID
INNER JOIN (
	SELECT computerID, IF(drives.Letter='C', drives.SSD, 0) AS SSD
	FROM drives
	GROUP BY computerID
)drives ON computers.computerID = drives.ComputerID
WHERE computers.ClientID=87
ORDER BY computers.Name