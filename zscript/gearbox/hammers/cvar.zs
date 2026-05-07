/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2020-2021
 *
 * This file is part of Gearbox.
 *
 * Gearbox is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Gearbox is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Gearbox.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * Cached PlayerInfo CVar pointer. Must use CVar.GetCVar(name, player) for user
 * CVARINFO entries (Cvar.getCvar is unreliable for those on some engine lines).
 */
class gb_Cvar
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  gb_Cvar from(string name)
  {
    let result = new("gb_Cvar");

    result.mName = name;
    result.load();

    return result;
  }

  string getString()
  {
    ensure();
    return mCvar ? mCvar.GetString() : "";
  }

  bool getBool()
  {
    ensure();
    return mCvar ? mCvar.GetBool() : false;
  }

  int getInt()
  {
    ensure();
    return mCvar ? mCvar.GetInt() : 0;
  }

  double getDouble()
  {
    ensure();
    return mCvar ? mCvar.GetFloat() : 0.;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private void ensure()
  {
    if (!mCvar) load();
  }

  private void load()
  {
    PlayerInfo plr = players[consoleplayer];
    if (!plr)
    {
      mCvar = null;
      return;
    }
    mCvar = CVar.GetCVar(mName, plr);

    if (mCvar == null)
    {
      gb_Log.error(string.Format("cvar %s not found", mName));
    }
  }

  private string         mName;
  private transient Cvar mCvar;

} // class gb_Cvar
