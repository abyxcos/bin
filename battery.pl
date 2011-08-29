#!/usr/bin/perl
# Reads (Linux) battery statistics, and returns various monitors
# Arguments are iterated over, and monitors are returned in the order specified
# Multiple monitors may be returned
# 
# Sampe usable 'battery.pl -m -p -t'
open(my $sys_charging, "<", "/sys/class/power_supply/BAT0/status");
open(my $sys_full, "<", "/sys/class/power_supply/BAT0/energy_full");
open(my $sys_now, "<", "/sys/class/power_supply/BAT0/energy_now");
open(my $sys_rate, "<", "/sys/class/power_supply/BAT0/power_now");

chomp(my $charging = <$sys_charging>);
my $capacity = <$sys_full>;
my $current = <$sys_now>;
my $rate = <$sys_rate>;

sub battery_time {
	my $status = "";
	my $time = "";
	if ($charging eq "Discharging") {
		$status = "-";
		$time = $current/$rate;
	} else {
		$status = "+";
		$time = $rate/$capacity;
	}

	return sprintf("%s%.1f hours", $status, $time);
}

sub battery_percent {
	return sprintf("%d%%", 100 * $current/$capacity);
}

sub battery_meter {
	if ($charging eq "Discharging") {
		my $meter = "[";
		for (my $i=4; $i>0; $i--) {
			if ($current/$capacity > 0.45/$i) {
				if ($current/$capacity > 0.95/$i) {
					$meter .= ":";
				} else {
					$meter .= ".";
				}
			} else {
				$meter .= " ";
			}
		}
		$meter .= "]";
		return $meter;
	} else {
		return "[ -E ]";
	}
}

my %args = (
	"-t" => \&battery_time,
	"-p" => \&battery_percent,
	"-m" => \&battery_meter,
);

my $battery_string = "";
foreach my $arg (@ARGV) {
	if ($args{$arg}) { $battery_string .= $args{$arg}->() . " "; }
}

$battery_string =~ s/\s+$//;
print $battery_string;

