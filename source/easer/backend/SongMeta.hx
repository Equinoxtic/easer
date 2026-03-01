package easer.backend;

class SongMeta {
	public static function getCredits(song:ChartData):Dynamic {
		var values:Dynamic = song.meta.customValues;
		return {
			author: values.author,
			charter: values.charter,
			modcharter: values.modcharter
		}
	}
}
