import React from "react"
import PropTypes from "prop-types"

let count = 0

class BandCreate extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      forms: [0]
    };
    this.handleAddForm = this.handleAddForm.bind(this)
    this.handleDeleteForm = this.handleDeleteForm.bind(this)
  }

  handleAddForm(e) {
    e.preventDefault()
    count++
    let forms = this.state.forms
    forms.push(count)
    console.log(forms)
    this.setState({
      forms: forms
    })
  }

  handleDeleteForm(e) {
    e.preventDefault
    count--
    let forms = this.state.forms
    forms.pop();
    this.setState({
      forms: forms
    });
  }

  render() {
    return (
        <form enctype="multipart/form-data" action="/bands" accept-charset="UTF-8" method="post">
          <input type="hidden" name="authenticity_token" value={this.props.token}></input>
          <h3>皆が使いやすいようにバンド名は正式名称で入力してください</h3>
          <label>バンド名を入力</label>
          <input type="text" name="band[name]" />
          <div className="field">
            <label>画像</label>
              <input type="file" name="band[image]" id="band_image"/>
          </div>

        {this.state.forms.map((form) =>
          <span key={form.toString()}>
            <div className="nested-fields">
              <label>メンバー名</label>
              <select name={`band[relationships_attributes][${form}][user_id]`}>
                {this.props.collections.map(collection => <option key={collection[1].toString()} value={collection[1]}>{collection[0]}</option>)}
              </select>
              <label>パート</label>
              <select name={`band[relationships_attributes][${form}][part]`}>
                <option value="Vo1">Vo1</option>
                <option value="Vo2">Vo2</option>
                <option value="GtVo">GtVo</option>
                <option value="BaVo">BaVo</option>
                <option value="Gt1">Gt1</option>
                <option value="Gt2">Gt2</option>
                <option value="Ba">Ba</option>
                <option value="Dr">Dr</option>
                <option value="Key">Key</option>
                <option value="その他">その他</option>
              </select>
              <input value="false" type="hidden" name={`band[relationships_attributes][${form}][_destroy]`} />
            </div>
          </span>
        )}
          < button type="button" disabled={count > 8} onClick={this.handleAddForm}>メンバーを追加</button>
          <button type="button" disabled={count < 1} onClick={this.handleDeleteForm}>メンバーを削除</button>
        <input type="submit" name="commit" value="確定する" data-confirm="本当によろしいですか？" className="btn btn-primary">
        </input>
        </form>
    );
  }
}

export default BandCreate
