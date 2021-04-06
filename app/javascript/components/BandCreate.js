import React from "react"
import PropTypes from "prop-types"

let count = 0

class BandCreate extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      forms: [0],
      name: "",
      name_error: true,
      user_duplicate_error: false,
      not_found_current_user_error: true,
    };
    this.handleAddForm = this.handleAddForm.bind(this)
    this.handleDeleteForm = this.handleDeleteForm.bind(this)
    this.handleSelectValidation = this.handleSelectValidation.bind(this)
    this.handleClickSubmit = this.handleClickSubmit.bind(this)
  }

  handleChangeName(event) {
    const inputValue = event.target.value;
    this.setState({
      name: inputValue
    });
    if (inputValue == "") {
      this.setState({
        name_error: true,
      });
    } else {
      this.setState({
        name_error: false,
      })
    }
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
    this.handleSelectValidation();
  }

  handleSelectValidation() {
    let user_ids = [];
    let forms = this.state.forms;
    forms.map((form) => {
      let user_id = document.getElementById(`band[relationships_attributes][${form}][user_id]`).value;
      user_ids.push(user_id);
    });
    let new_user_ids = user_ids.filter(u => u != "0");
    let not_found_current_user_error = !new_user_ids.includes(this.props.current_user_id);
    let set = new Set(new_user_ids);
    let user_duplicate_error = set.size != new_user_ids.length;
    this.setState({
      user_duplicate_error: user_duplicate_error,
      not_found_current_user_error: not_found_current_user_error,
    });
  }

  handleClickSubmit() {
    let forms = this.state.forms;
    forms.map((form) => {
      let user_id = document.getElementById(`band[relationships_attributes][${form}][user_id]`).value;
      if (user_id == this.props.current_user_id) {
        document.getElementById(`band[relationships_attributes][${form}][permission]`).value = "true";
      }
    });
  }

  render() {

    let name_error_message
    if (this.state.name_error) {
      name_error_message = (
        <div class="dynamic_error_message">※バンド名が入力されていません</div>
      );
    } else {
      name_error_message = "";
    }

    let user_dupulicate_error_message
    if (this.state.user_duplicate_error) {
      user_dupulicate_error_message = (
        <div class="dynamic_error_message">※メンバーが重複しています</div>
      );
    } else {
      user_dupulicate_error_message = "";
    }

    let not_found_current_user_error_message
    if (this.state.not_found_current_user_error) {
      not_found_current_user_error_message = (
        <div class="dynamic_error_message">※作成者はバンドに所属してください</div>
      );
    } else {
      not_found_current_user_error_message = "";
    }

    return (
      <form
        enctype="multipart/form-data"
        action="/bands"
        accept-charset="UTF-8"
        method="post"
      >
        <input
          type="hidden"
          name="authenticity_token"
          value={this.props.token}
        ></input>

        {name_error_message}
        {not_found_current_user_error_message}
        {user_dupulicate_error_message}
        <p></p>
        <div className="field">
          <label>画像</label> <br/>
          <input type="file" name="band[image]" id="band_image" />
        </div>

        <label className="label-margin">バンド名を入力</label>
        <input
          onChange={(event) => {
            this.handleChangeName(event);
          }}
          type="text"
          name="band[name]"
          class="form-control"
        />

        <div className="row">
          <div className="col"></div>
          <div className="col"></div>
        </div>

        {this.state.forms.map((form) => (
          <span key={form.toString()}>
            <div className="nested-fields">
              <div className="row">
                <div className="col">
                  <label className="label-margin">メンバー名</label>
                  <select
                    onChange={this.handleSelectValidation}
                    className="form-control"
                    name={`band[relationships_attributes][${form}][user_id]`}
                    id={`band[relationships_attributes][${form}][user_id]`}
                  >
                    {this.props.collections.map((collection) => (
                      <option
                        key={collection[1].toString()}
                        value={collection[1]}
                      >
                        {collection[0]}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="col">
                  {" "}
                  <label className="label-margin">パート</label>
                  <select
                    name={`band[relationships_attributes][${form}][part]`}
                    className="form-control"
                  >
                    <option value="Vocal">Vocal</option>
                    <option value="Guitar&Vocal">Guitar&Vocal</option>
                    <option value="Bass&Vocal">Bass&Vocal</option>
                    <option value="LeadGuitar">LeadGuitar</option>
                    <option value="RhythmGuitar">RhythmGuitar</option>
                    <option value="Bass">Bass</option>
                    <option value="Drums">Drums</option>
                    <option value="Keyboard">Keyboard</option>
                    <option value="その他">その他</option>
                  </select>
                </div>
              </div>

              <input
                value="false"
                type="hidden"
                name={`band[relationships_attributes][${form}][permission]`}
                id={`band[relationships_attributes][${form}][permission]`}
              />
              <input
                value="false"
                type="hidden"
                name={`band[relationships_attributes][${form}][_destroy]`}
              />
            </div>
          </span>
        ))}
        <button
          type="button"
          className="btn btn-secondary btn-sm"
          disabled={count > 8}
          onClick={this.handleAddForm}
        >
          メンバーを追加
        </button>
        <button
          type="button"
          className="btn btn-secondary btn-sm"
          disabled={count < 1}
          onClick={this.handleDeleteForm}
        >
          メンバーを削除
        </button>

        <input
          onClick={this.handleClickSubmit}
          disabled={
            this.state.name_error ||
            this.state.user_duplicate_error ||
            this.state.not_found_current_user_error
          }
          type="submit"
          name="commit"
          value="確定する"
          data-confirm="本当によろしいですか？"
          className="btn btn-primary btn-block"
        ></input>
      </form>
    );
  }
}

export default BandCreate
