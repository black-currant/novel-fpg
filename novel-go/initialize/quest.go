package initialize

import (
	"io/ioutil"
	"strings"

	"github.com/go-gota/gota/dataframe"
	"github.com/go-gota/gota/series"
)

func LoadQuest() *dataframe.DataFrame {
	content, _ := ioutil.ReadFile("./static/data/quest.csv")
	if content[0] == 0xef || content[1] == 0xbb || content[2] == 0xbf {
		content = content[3:]
	}
	ioContent := strings.NewReader(string(content))
	df := dataframe.ReadCSV(ioContent)
	df = df.Filter(
		dataframe.F{
			Colname:    "Task State",
			Comparator: series.Eq,
			Comparando: "published",
		},
	)
	return &df
}
