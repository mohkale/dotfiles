import logging
import math

from .base import StatusMiscSegment


class BatteryLifeSegment(StatusMiscSegment):
    name = "battery"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.threshold = sorted(
            [(float(threshold), style) for threshold, style in self.threshold],
            key=lambda it: it[0],
            reverse=True,
        )

    @classmethod
    def parser_args(cls, parser):
        battery_group = parser.add_argument_group("Battery Life")
        battery_group.add_argument(
            f"--{cls.name}-level",
            default=("E", "H", "F"),
            nargs="+",
            metavar="ICON",
            help="Specify icon list for battery value range.",
        )
        battery_group.add_argument(
            f"--{cls.name}-alert",
            default="W",
            metavar="ICON",
            help="Icon shown when battery is about to be drained.",
        )
        battery_group.add_argument(
            f"--{cls.name}-charging",
            metavar="ICON",
            help="Icon shown when battery is being charged.",
        )
        battery_group.add_argument(
            f"--{cls.name}-count",
            type=int,
            default=4,
            help="How many times to repeat {cls.name}-level",
        )
        battery_group.add_argument(
            f"--{cls.name}-alert-duration",
            type=int,
            metavar="SECONDS",
            default=60 * 5,
            help="Duration (until battery is empty) before which alert icon is shown",
        )
        for it, desc in (
            (
                f"--{cls.name}-charging-threshold",
                "Specify style thresholds for the charging icon",
            ),
            (
                f"--{cls.name}-threshold",
                "Specify style thresholds for each battery icon",
            ),
        ):
            battery_group.add_argument(
                it,
                nargs=2,
                metavar=("PERCENT", "STYLE"),
                action="append",
                default=[],
                help=desc,
            )

        battery_group.add_argument(
            f"--{cls.name}-include-duration",
            action="store_true",
            help="Include time to discharge",
        )

        for flag, doc in (
            (f"--{cls.name}-style", "Default style for battery icons"),
            (f"--{cls.name}-alert-style", "Style for charging icon"),
            (f"--{cls.name}-duration-style", "Style for time to discharge duration"),
            (f"--{cls.name}-charging-style", "Style for charging icon"),
        ):
            battery_group.add_argument(flag, metavar="STYLE", default="", help=doc)

    @staticmethod
    def _battery_sensors():
        try:
            import psutil
        except ImportError:
            logging.warning("Failed to import psutil")
            return None
        try:
            return psutil.sensors_battery()
        except NameError:
            return None

    def _format_hearts(self, batt):
        active_hearts = self.count * batt.percent / 100.0
        full = math.floor(active_hearts)
        charging = active_hearts - full

        hearts = self._style((full * self.level[-1]), self.style)
        if charging != 0:
            for threshold, style in self.threshold:
                if batt.percent >= threshold:
                    hearts_style = style
                    break
            else:
                hearts_style = self.style
            hearts += self._style(
                self.level[math.ceil((len(self.level) - 1) * min(charging, 1))],
                hearts_style,
            )
        empty = self.count - (full + math.ceil(charging))
        if empty > 0:
            hearts += self._style((empty * self.level[0]), self.style)
        return hearts

    def _format_charging(self, batt):
        for threshold, style in self.charging_threshold:
            if batt.percent >= threshold:
                charging_style = style
                break
        else:
            charging_style = self.charging_style
        return self._style(self.charging, charging_style)

    def _format_duration(self, batt):
        if not isinstance(batt.secsleft, int):
            return None
        hours, rem = divmod(batt.secsleft, 60 ** 2)
        minutes, seconds = divmod(rem, 60)
        duration = ""
        if hours != 0:
            duration = f"{hours:02d}:{minutes:02d} H"
        if minutes != 0:
            duration = f"{minutes:02d}:{seconds:02d} M"
        else:
            duration = f"{seconds:02d} S"
        return self._style(duration, duration_style)

    def _format_alert(self, batt):
        return self._style(self.alert, self.alert_style)

    def render(self):
        batt = self._battery_sensors()
        if batt.power_plugged and self.charging:
            return self._format_charging(batt)
        if (
            self.alert_duration is not None
            and isinstance(batt.secsleft, int)
            and batt.secsleft < self.alert_duration
        ):
            return self._format_alert(batt)
        result = self._format_hearts(batt)
        if self.include_duration:
            duration = self._format_duration(batt)
            if duration is not None:
                result += f" {duration}"
        return result
