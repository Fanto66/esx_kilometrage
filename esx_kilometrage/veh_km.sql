CREATE TABLE `kilometrage` (
  `carplate` varchar(10) NOT NULL,
  `km` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `kilometrage`
  ADD PRIMARY KEY (`carplate`),
  ADD UNIQUE KEY `carplate` (`carplate`),
  ADD KEY `carplate_2` (`carplate`);
COMMIT;
